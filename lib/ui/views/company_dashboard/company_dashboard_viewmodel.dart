import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import '../../../services/notification_service.dart';
import '../../../core/enums/application_status.dart';

enum ChartPeriod { weekly, monthly, yearly }

class ApplicantChartPoint {
  final String label;
  final int count;
  ApplicantChartPoint({required this.label, required this.count});
}

class Applicant {
  final String id;
  final String name;
  final String university;
  final String department;
  final String gpa;
  final String skills;
  final String about;
  final int matchScore;
  ApplicationStatus status;
  final String? meetingUrl;
  final String? meetingDate;
  final DateTime? appliedAt;

  Applicant({
    required this.id,
    required this.name,
    required this.university,
    required this.department,
    required this.gpa,
    required this.skills,
    required this.about,
    required this.matchScore,
    this.status = ApplicationStatus.applied,
    this.meetingUrl,
    this.meetingDate,
    this.appliedAt,
  });
}

class JobListing {
  final String id;
  final String title;
  final String department;
  final String type;
  final String location;
  final DateTime postedAt;
  final List<Applicant> applicants;
  final String description;
  final String requirements;
  final String benefits;
  final String duration;
  final String compensationType;
  final bool isActive;
  final DateTime? deadline;

  JobListing({
    required this.id,
    required this.title,
    required this.department,
    required this.type,
    required this.location,
    required this.postedAt,
    required this.applicants,
    this.description = '',
    this.requirements = '',
    this.benefits = '',
    this.duration = '',
    this.compensationType = '',
    this.isActive = true,
    this.deadline,
  });

  int get applicantCount => applicants.length;
  int get interviewCount =>
      applicants.where((a) => a.status == ApplicationStatus.interview).length;
  int get offerCount =>
      applicants.where((a) => a.status == ApplicationStatus.hired).length;
}

class CompanyDashboardViewModel extends BaseViewModel {
  List<JobListing> _jobs = [];
  List<JobListing> get jobs => _jobs;
  List<JobListing> get activeJobs => _jobs.where((j) => j.isActive).toList();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  static String daysSince(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Bugün';
    if (diff == 1) return 'Dün';
    return '$diff gün önce';
  }

  // Overall stats
  int get totalApplicants => _jobs.fold(0, (sum, j) => sum + j.applicantCount);
  int get totalInterviews => _jobs.fold(0, (sum, j) => sum + j.interviewCount);
  int get totalOffers => _jobs.fold(0, (sum, j) => sum + j.offerCount);
  int get totalJobs => _jobs.length;
  int get activeJobCount => activeJobs.length;

  final _supabaseService = locator<SupabaseService>();

  void init() {
    _fetchJobs();
  }

  Future<void> refresh() async {
    _errorMessage = null;
    await _fetchJobs();
  }

  ApplicationStatus _parseStatus(String? statusText) {
    return ApplicationStatus.fromString(statusText);
  }

  Future<void> _fetchJobs() async {
    setBusy(true);

    try {
      final rawJobs = await _supabaseService.getCompanyJobs();

      _jobs = rawJobs.map((jobMap) {
        final jobApplications = jobMap['job_applications'] as List? ?? [];

        final parsedApplicants = jobApplications.map((appRaw) {
          final app = appRaw as Map<String, dynamic>;
          final student = app['student_profiles'] as Map<String, dynamic>?;

          final statusString = app['status']?.toString() ?? 'pending';
          final parsedStatus = _parseStatus(statusString);

          String fName = student?['first_name']?.toString() ?? '';
          String lName = student?['last_name']?.toString() ?? '';
          String fullName = '$fName $lName'.trim();
          if (fullName.isEmpty) fullName = 'Bilinmeyen Aday';

          int matchScore = 0; // Ideally calculated, we set a default
          if (student?['gpa'] != null) {
            matchScore +=
                (double.tryParse(student!['gpa'].toString()) ?? 0.0) * 10 > 40
                ? 40
                : (double.tryParse(student['gpa'].toString()) ?? 0.0).toInt() *
                      10;
          } else {
            matchScore = 70; // fallback
          }

          DateTime? appliedAt;
          try {
            final raw = app['applied_at'] ?? app['created_at'];
            if (raw != null) {
              appliedAt = DateTime.parse(raw.toString()).toLocal();
            }
          } catch (_) {}

          return Applicant(
            id: app['student_id']?.toString() ?? '',
            name: fullName,
            university: student?['university']?.toString() ?? 'Belirtilmemiş',
            department: student?['department']?.toString() ?? 'Belirtilmemiş',
            gpa: student?['gpa']?.toString() ?? '-',
            skills: (student?['skills'] is List)
                ? (student!['skills'] as List).join(', ')
                : (student?['skills']?.toString() ?? ''),
            about: student?['about']?.toString() ?? '',
            matchScore: matchScore > 100
                ? 100
                : (matchScore < 50 ? 50 : matchScore),
            status: parsedStatus,
            meetingUrl: app['meeting_url']?.toString(),
            meetingDate: app['meeting_date']?.toString(),
            appliedAt: appliedAt,
          );
        }).toList();

        DateTime? deadlineDate;
        try {
          final rawDeadline = jobMap['deadline'];
          if (rawDeadline != null) {
            deadlineDate = DateTime.parse(rawDeadline.toString()).toLocal();
          }
        } catch (_) {}

        return JobListing(
          id: jobMap['id']?.toString() ?? '',
          title: jobMap['title']?.toString() ?? 'İlan',
          department: jobMap['department']?.toString() ?? '',
          type: jobMap['work_type']?.toString() ?? '',
          location: jobMap['location']?.toString() ?? '',
          postedAt: jobMap['created_at'] != null
              ? DateTime.parse(jobMap['created_at'].toString())
              : DateTime.now(),
          applicants: parsedApplicants,
          description: jobMap['description']?.toString() ?? '',
          requirements: jobMap['requirements']?.toString() ?? '',
          benefits: jobMap['benefits']?.toString() ?? '',
          duration: jobMap['duration']?.toString() ?? '',
          compensationType: jobMap['compensation_type']?.toString() ?? '',
          isActive: jobMap['is_active'] as bool? ?? true,
          deadline: deadlineDate,
        );
      }).toList();
    } catch (e) {
      _errorMessage = 'İlanlar yüklenirken bir hata oluştu. Lütfen tekrar deneyin.';
    } finally {
      setBusy(false);
    }
  }

  List<ApplicantChartPoint> getApplicantChartData(ChartPeriod period) {
    final allApplicants = _jobs.expand((j) => j.applicants).toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case ChartPeriod.weekly:
        final weekLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
        return List.generate(7, (i) {
          final day = today.subtract(Duration(days: 6 - i));
          final count = allApplicants.where((a) {
            if (a.appliedAt == null) return false;
            final d = DateTime(a.appliedAt!.year, a.appliedAt!.month, a.appliedAt!.day);
            return d == day;
          }).length;
          return ApplicantChartPoint(label: weekLabels[day.weekday - 1], count: count);
        });

      case ChartPeriod.monthly:
        return List.generate(4, (i) {
          final daysBack = (3 - i) * 7;
          final weekEnd = today.subtract(Duration(days: daysBack));
          final weekStart = weekEnd.subtract(const Duration(days: 6));
          final count = allApplicants.where((a) {
            if (a.appliedAt == null) return false;
            final d = DateTime(a.appliedAt!.year, a.appliedAt!.month, a.appliedAt!.day);
            return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
          }).length;
          return ApplicantChartPoint(label: 'H${i + 1}', count: count);
        });

      case ChartPeriod.yearly:
        const monthLabels = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
        return List.generate(12, (i) {
          final target = DateTime(now.year, now.month - 11 + i);
          final count = allApplicants.where((a) {
            if (a.appliedAt == null) return false;
            return a.appliedAt!.year == target.year && a.appliedAt!.month == target.month;
          }).length;
          return ApplicantChartPoint(label: monthLabels[target.month - 1], count: count);
        });
    }
  }

  Future<void> updateStatus(
    String jobId,
    String applicantId,
    ApplicationStatus status, {
    String? meetingUrl,
    String? meetingDate,
  }) async {
    final jobIdx = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIdx == -1) return;
    final job = _jobs[jobIdx];
    final applicantIdx = job.applicants.indexWhere((a) => a.id == applicantId);
    if (applicantIdx == -1) return;
    final applicant = job.applicants[applicantIdx];

    final oldStatus = applicant.status;
    applicant.status = status;
    notifyListeners();

    try {
      await _supabaseService.updateApplicationStatus(
        studentId: applicantId,
        jobId: jobId,
        status: status.name,
        meetingUrl: meetingUrl,
        meetingDate: meetingDate,
      );

      // Send push notification + persist to notifications table
      final notifyService = locator<NotificationService>();
      notifyService.sendNotificationToUser(
        targetUserId: applicantId,
        title: 'Başvuru Güncellemesi: ${job.title}',
        message: 'Başvurunuz "${status.label}" aşamasına geçti!',
      );
      _supabaseService.insertNotification(
        userId: applicantId,
        title: 'Başvuru Güncellemesi: ${job.title}',
        message: 'Başvurunuz "${status.label}" aşamasına geçti!',
        type: 'application_status_update',
        relatedId: jobId,
      );
    } catch (e) {
      // Revert on failure
      applicant.status = oldStatus;
      notifyListeners();
    }
  }
}
