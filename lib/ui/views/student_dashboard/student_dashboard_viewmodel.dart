import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.router.dart';
import '../../../services/supabase_service.dart';
import '../../../core/models/job_listing.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/app_tops.dart';
import '../applied_jobs/application_tracker_view.dart';

class StudentDashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _supabaseService = locator<SupabaseService>();

  List<Map<String, dynamic>> aiSuggestions = [];
  List<JobListing> recentJobs = [];
  List<Map<String, dynamic>> appliedJobs = [];
  List<NotificationModel> _notifications = [];

  // ── Search ──────────────────────────────────────────────────────────
  String searchQuery = '';
  String selectedCategory = 'Tümü';
  bool allJobsLoaded = false;

  // ── Filter state ─────────────────────────────────────────────────────
  Set<String> filterCategories = {};
  Set<String> filterWorkTypes = {};
  Set<String> filterCompensations = {};
  String? filterDateRange;
  Set<String> filterDurations = {};

  int get activeFilterCount =>
      filterCategories.length +
      filterWorkTypes.length +
      filterCompensations.length +
      (filterDateRange != null ? 1 : 0) +
      filterDurations.length;

  bool get hasActiveFilters => activeFilterCount > 0;

  /// Shows search/filter results panel when user is searching OR has active filters.
  bool get isSearchActive => searchQuery.isNotEmpty || hasActiveFilters;

  // ── Filtered results ─────────────────────────────────────────────────
  List<JobListing> get filteredJobs {
    final q = searchQuery.toLowerCase();
    final now = DateTime.now();

    return AppTops.allJobs.where((job) {
      // Search query
      final matchesSearch =
          q.isEmpty ||
          job.title.toLowerCase().contains(q) ||
          (job.company?.companyName.toLowerCase().contains(q) ?? false) ||
          job.location.toLowerCase().contains(q) ||
          job.department.toLowerCase().contains(q);

      // Category (chip bar when no filter sheet category, else filter sheet)
      final matchesCategory = filterCategories.isNotEmpty
          ? filterCategories.any((cat) => _matchesCategory(job, cat))
          : (selectedCategory == 'Tümü' ||
                _matchesCategory(job, selectedCategory));

      // Work type
      final matchesWorkType =
          filterWorkTypes.isEmpty ||
          filterWorkTypes.any(
            (wt) => job.workType.toLowerCase().contains(wt.toLowerCase()),
          );

      // Compensation
      final matchesCompensation =
          filterCompensations.isEmpty ||
          filterCompensations.any(
            (c) => job.compensationType.toLowerCase().contains(c.toLowerCase()),
          );

      // Date range
      final matchesDate =
          filterDateRange == null ||
          _matchesDateRange(job, filterDateRange!, now);

      // Duration
      final matchesDuration =
          filterDurations.isEmpty ||
          filterDurations.any(
            (d) => job.duration.toLowerCase().contains(d.toLowerCase()),
          );

      return matchesSearch &&
          matchesCategory &&
          matchesWorkType &&
          matchesCompensation &&
          matchesDate &&
          matchesDuration;
    }).toList();
  }

  /// [AppTops.categories] yüklüyse id karşılaştırması yapar.
  /// Kategoriler yüklenmediyse veya ilanın category_id'si yoksa true döner (dahil et).
  bool _matchesCategory(JobListing job, String categoryName) {
    if (AppTops.categories.isEmpty) return true;
    final matches = AppTops.categories.where(
      (c) => c.categoryName == categoryName,
    );
    if (matches.isEmpty) return true;
    final category = matches.first;
    if (job.categoryId == null) return true;
    return job.categoryId == category.id;
  }

  bool _matchesDateRange(JobListing job, String range, DateTime now) {
    if (job.createdAt == null) return false;
    final diff = now.difference(job.createdAt!).inDays;
    switch (range) {
      case 'Bugün':
        return diff < 1;
      case 'Son 3 Gün':
        return diff <= 3;
      case 'Son 1 Hafta':
        return diff <= 7;
      case 'Son 1 Ay':
        return diff <= 30;
      default:
        return true;
    }
  }

  // ── Filter actions ────────────────────────────────────────────────────
  void applyFilters({
    required Set<String> categories,
    required Set<String> workTypes,
    required Set<String> compensations,
    required String? dateRange,
    required Set<String> durations,
  }) {
    filterCategories = Set.from(categories);
    filterWorkTypes = Set.from(workTypes);
    filterCompensations = Set.from(compensations);
    filterDateRange = dateRange;
    filterDurations = Set.from(durations);
    notifyListeners();
  }

  void clearFilters() {
    filterCategories = {};
    filterWorkTypes = {};
    filterCompensations = {};
    filterDateRange = null;
    filterDurations = {};
    notifyListeners();
  }

  // ── Profile ───────────────────────────────────────────────────────────
  String get firstName {
    final name = AppTops.studentProfile?.firstName?.trim() ?? '';
    return name.isNotEmpty ? name.split(' ').first : 'Öğrenci';
  }

  // ── Init ──────────────────────────────────────────────────────────────
  void init() {
    fetchAiSuggestions();
    fetchRecentJobs();
    fetchNotifications();
    _loadAllJobs();
  }

  Future<void> _loadAllJobs() async {
    await _supabaseService.getAllJobs();
    allJobsLoaded = true;
    notifyListeners();
  }

  Future<void> fetchAiSuggestions() async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 2));
    aiSuggestions = [
      {'title': 'Flutter Developer', 'company': 'TechNova', 'match': 92},
      {
        'title': 'Mobil Uygulama Geliştiricisi',
        'company': 'AppWorks',
        'match': 85,
      },
      {'title': 'Dart Developer Intern', 'company': 'StartupX', 'match': 78},
    ];
    setBusy(false);
  }

  Future<void> fetchRecentJobs() async {
    setBusy(true);
    try {
      recentJobs = await _supabaseService.getRecentJobs();
    } catch (e) {
      debugPrint('Error fetching recent jobs: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> fetchNotifications() async {
    try {
      _notifications = await _supabaseService.getUserNotifications();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(NotificationModel notification) async {
    if (notification.isRead) return;
    final idx = _notifications.indexWhere((n) => n.id == notification.id);
    if (idx != -1) {
      _notifications[idx] = notification.copyWith(isRead: true);
      notifyListeners();
    }
    await _supabaseService.markNotificationAsRead(notification.id);
  }

  Future<void> navigateToNotification(NotificationModel notification) async {
    await markNotificationAsRead(notification);

    if (notification.relatedId == null) return;

    // Fetch the specific application for this job to open the tracker
    final appData = await _supabaseService.getApplicationByJobId(
      notification.relatedId!,
    );

    if (appData != null) {
      StackedService.navigatorKey?.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ApplicationTrackerView(applicationData: appData),
        ),
      );
      return;
    }

    // Fallback: navigate to job detail if no application found
    final cached = AppTops.allJobs.where((j) => j.id == notification.relatedId);
    if (cached.isNotEmpty) {
      _navigationService.navigateToJobDetailView(job: cached.first);
      return;
    }
    final job = await _supabaseService.getJobById(notification.relatedId!);
    if (job != null) {
      _navigationService.navigateToJobDetailView(job: job);
    }
  }

  List<NotificationModel> get notifications => _notifications;

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  List<Map<String, dynamic>> get activeApplications {
    return appliedJobs.where((app) {
      final status = app['status']?.toString().toLowerCase() ?? '';
      return status != 'applied' && status != 'pending';
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void onCategoryChanged(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void navigateToJobDetailMap(JobListing job) {
    _navigationService.navigateToJobDetailView(job: job);
  }

  void navigateToJobDetail(JobListing job) {
    // final Map<String, dynamic> jobMap = {
    //   'title': job.title,
    //   'company': job.company?.companyName ?? 'Bilinmeyen Şirket',
    //   'match': 0,
    //   'id': job.id,
    //   'location': job.location,
    //   'work_type': job.workType,
    //   'description': job.description,
    //   'requirements': job.requirements,
    //   'benefits': job.benefits,
    //   'company_description': job.company?.description,
    //   'contact_phone': job.company?.phone,
    //   'category_id': job.categoryId,
    // };
    _navigationService.navigateToJobDetailView(job: job);
  }
}
