import 'package:flutter/foundation.dart';
import 'package:intern_app/core/app_tops.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/category.dart' as app_models;
import '../core/models/company_profile.dart';
import '../core/models/student_profile.dart';
import '../core/models/job_listing.dart';
import '../core/models/notification_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  CompanyProfile? _currentCompanyProfile;
  StudentProfile? _currentStudentProfile;
  List<JobListing>? _cachedRecentJobs;
  List<JobListing>? _cachedSavedJobs;

  /// `categories` tablosundaki tüm kategorileri çekip [AppTops.categories]'e yazar.
  Future<void> getCategories({bool forceRefresh = false}) async {
    if (!forceRefresh && AppTops.categories.isNotEmpty) return;
    try {
      final response = await _supabase
          .from('categories')
          .select('id, category_name')
          .order('id', ascending: true);
      AppTops.categories = (response as List)
          .map((c) => app_models.Category.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error in getCategories: $e');
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required bool isStudent,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'is_student': isStudent},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    _currentCompanyProfile = null;
    _currentStudentProfile = null;
    _cachedRecentJobs = null;
    _cachedSavedJobs = null;
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _supabase.auth.signInWithOAuth(
      provider,
      redirectTo: 'io.supabase.internapp://callback',
    );
  }

  // Future methods for Vector Search and fetching data will be added here

  Future<CompanyProfile?> getCompanyProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _currentCompanyProfile != null) {
      return _currentCompanyProfile;
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await _supabase
        .from('company_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response != null) {
      _currentCompanyProfile = CompanyProfile.fromJson(response);
    } else {
      _currentCompanyProfile = null;
    }
    return _currentCompanyProfile;
  }

  Future<void> updateCompanyProfile(Map<String, dynamic> data) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Giriş yapılmamış.');

    // We use .update() here instead of .upsert() so that partial updates
    // (like just updating a logo_url or cv_url) don't trigger NOT NULL constraints
    // on other columns if the row already exists.
    await _supabase
        .from('company_profiles')
        .update({...data, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);

    // Refresh cache
    await getCompanyProfile(forceRefresh: true);
  }

  Future<StudentProfile?> getStudentProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _currentStudentProfile != null) {
      return _currentStudentProfile;
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await _supabase
        .from('student_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response != null) {
      _currentStudentProfile = StudentProfile.fromJson(response);
    } else {
      _currentStudentProfile = null;
    }
    return _currentStudentProfile;
  }

  Future<void> updateStudentProfile(Map<String, dynamic> data) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Giriş yapılmamış.');

    await _supabase
        .from('student_profiles')
        .update({...data, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);

    // Refresh cache
    await getStudentProfile(forceRefresh: true);
  }

  /// Uploads a file to a specific Supabase Storage bucket and returns the public URL.
  Future<String?> uploadFile({
    required String bucketName,
    required String path,
    required dynamic fileData, // Can be File or Uint8List for web
  }) async {
    try {
      await _supabase.storage.from(bucketName).upload(path, fileData);
      final url = _supabase.storage.from(bucketName).getPublicUrl(path);
      return url;
    } catch (e) {
      throw Exception('Dosya yüklenirken hata oluştu: $e');
    }
  }

  Future<void> createJobListing({
    required String title,
    required String department,
    required String location,
    required String workType,
    required String compensationType,
    required String duration,
    required String description,
    required String requirements,
    required String benefits,
    DateTime? deadline,
    int? categoryId,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Giriş yapılmamış.');

    _cachedRecentJobs = null;

    final data = <String, dynamic>{
      'company_id': userId,
      'title': title,
      'department': department,
      'location': location,
      'work_type': workType,
      'compensation_type': compensationType,
      'duration': duration,
      'description': description,
      'requirements': requirements,
      'benefits': benefits,
      'deadline': deadline?.toIso8601String(),
    };
    if (categoryId != null) data['category_id'] = categoryId;

    await _supabase.from('job_listings').insert(data);
  }

  Future<void> updateJobListing({
    required String jobId,
    required String title,
    required String location,
    required String workType,
    required String compensationType,
    required String duration,
    required String description,
    required String requirements,
    required String benefits,
    required bool isActive,
    DateTime? deadline,
  }) async {
    _cachedRecentJobs = null;
    await _supabase
        .from('job_listings')
        .update({
          'title': title,
          'location': location,
          'work_type': workType,
          'compensation_type': compensationType,
          'duration': duration,
          'description': description,
          'requirements': requirements,
          'benefits': benefits,
          'is_active': isActive,
          'deadline': deadline?.toIso8601String(),
        })
        .eq('id', jobId);
  }

  Future<List<JobListing>> getRecentJobs({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedRecentJobs != null) {
      return _cachedRecentJobs!;
    }

    try {
      final response = await _supabase
          .from('job_listings')
          .select('*, company_profiles(*)')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(10);

      debugPrint('Recent Jobs Response: $response');
      _cachedRecentJobs = (response as List)
          .map((job) => JobListing.fromJson(job))
          .toList();
      return _cachedRecentJobs!;
    } catch (e) {
      debugPrint('Error in getRecentJobs: $e');
      return [];
    }
  }

  Future<void> getAllJobs({bool forceRefresh = false}) async {
    if (!forceRefresh && AppTops.allJobs.isNotEmpty) return;
    try {
      final response = await _supabase
          .from('job_listings')
          .select('*, company_profiles(*)')
          .eq('is_active', true)
          .order('created_at', ascending: false);
      AppTops.allJobs = (response as List)
          .map((job) => JobListing.fromJson(job))
          .toList();
    } catch (e) {
      debugPrint('Error in getAllJobs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCompanyJobs() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('job_listings')
          .select('*, job_applications(*, student_profiles(*))')
          .eq('company_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error in getCompanyJobs: $e');
      return [];
    }
  }

  Future<void> updateApplicationStatus({
    required String studentId,
    required String jobId,
    required String status,
    String? meetingUrl,
    String? meetingDate,
  }) async {
    try {
      final updateData = <String, dynamic>{'status': status};
      if (meetingUrl != null) updateData['meeting_url'] = meetingUrl;
      if (meetingDate != null) updateData['meeting_date'] = meetingDate;

      await _supabase
          .from('job_applications')
          .update(updateData)
          .eq('student_id', studentId)
          .eq('job_id', jobId);
    } catch (e) {
      debugPrint('Error updating application status: $e');
      rethrow;
    }
  }

  Future<bool> isJobFavorited(String jobId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final response = await _supabase
          .from('student_favorite_jobs')
          .select()
          .eq('student_id', userId)
          .eq('job_id', jobId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

  Future<void> getAppliedJobsIds() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('job_applications')
          .select()
          .eq('student_id', userId);
      AppTops.appliedJobsIds = response
          .map((job) => job['job_id'].toString())
          .toList();
    } catch (e) {
      debugPrint('Error checking applied status: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAppliedJobs() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('job_applications')
          .select('*, job_listings(*, company_profiles(*))')
          .eq('student_id', userId)
          .order('applied_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting applied jobs: $e');
      return [];
    }
  }

  Future<bool> applyToJob(String jobId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Giriş yapılmamış.');

    try {
      await _supabase.from('job_applications').insert({
        'student_id': userId,
        'job_id': jobId,
        'status': 'pending',
        'applied_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error applying to job: $e');
      return false;
    }
  }

  Future<void> toggleFavoriteJob(
    String jobId,
    bool isCurrentlyFavorited,
  ) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Giriş yapılmamış.');

    if (isCurrentlyFavorited) {
      // Remove favorite
      await _supabase
          .from('student_favorite_jobs')
          .delete()
          .eq('student_id', userId)
          .eq('job_id', jobId);
    } else {
      // Add favorite
      await _supabase.from('student_favorite_jobs').insert({
        'student_id': userId,
        'job_id': jobId,
      });
    }

    // Invalidate the saved jobs cache so it reflects the change next time
    _cachedSavedJobs = null;
  }

  Future<Map<String, dynamic>?> getApplicationByJobId(String jobId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _supabase
          .from('job_applications')
          .select('*, job_listings(*, company_profiles(*))')
          .eq('student_id', userId)
          .eq('job_id', jobId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Error fetching application by job id: $e');
      return null;
    }
  }

  Future<JobListing?> getJobById(String jobId) async {
    try {
      final response = await _supabase
          .from('job_listings')
          .select('*, company_profiles(*)')
          .eq('id', jobId)
          .maybeSingle();

      if (response != null) {
        return JobListing.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching job by id: $e');
      return null;
    }
  }

  Future<List<NotificationModel>> getUserNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((n) => NotificationModel.fromMap(n as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> insertNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        if (relatedId != null) 'related_id': relatedId, // ignore: use_null_aware_elements
        'is_read': false,
      });
    } catch (e) {
      debugPrint('Error inserting notification: $e');
    }
  }

  Future<List<JobListing>> getSavedJobs({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedSavedJobs != null) {
      return _cachedSavedJobs!;
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      // Query the junction table and explicitly select the joined job_listings
      final response = await _supabase
          .from('student_favorite_jobs')
          .select('job_id, job_listings(*, company_profiles(*))')
          .eq('student_id', userId)
          .order('created_at', ascending: false);

      debugPrint('Saved Jobs Response: $response');

      final List<JobListing> jobs = [];
      for (final row in response as List) {
        final jobData = row['job_listings'];
        if (jobData != null && jobData is Map<String, dynamic>) {
          jobs.add(JobListing.fromJson(jobData));
        }
      }
      _cachedSavedJobs = jobs;
      return jobs;
    } catch (e) {
      debugPrint('Error getting saved jobs: $e');
      return [];
    }
  }
}
