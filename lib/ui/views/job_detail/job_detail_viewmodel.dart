import 'package:flutter/foundation.dart';
import 'package:intern_app/core/models/job_listing.dart';
import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../core/app_tops.dart';
import '../../../services/supabase_service.dart';

class JobDetailViewModel extends BaseViewModel {
  final _supabaseService = locator<SupabaseService>();
  final JobListing job;
  bool isApplied = false;

  bool isFavorited = false;

  JobDetailViewModel(this.job);

  Future<void> init() async {
    setBusy(true);
    final jobId = job.id;
    if (jobId.isNotEmpty) {
      isFavorited = await _supabaseService.isJobFavorited(jobId);
      isApplied = AppTops.appliedJobsIds.contains(jobId);
    }
    setBusy(false);
  }

  Future<void> toggleFavorite() async {
    final jobId = job.id;
    if (jobId.isEmpty) return;

    try {
      // Optimitic UI update
      isFavorited = !isFavorited;
      notifyListeners();

      await _supabaseService.toggleFavoriteJob(
        jobId,
        !isFavorited,
      ); // Note: we passed the old state
    } catch (e) {
      // Revert on error
      isFavorited = !isFavorited;
      notifyListeners();
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<bool> applyToJob() async {
    // Add application logic later (e.g. Supabase DB insert)
    final jobId = job.id;
    if (jobId.isEmpty) return false;

    try {
      await _supabaseService.applyToJob(jobId);
      isApplied = true;
      AppTops.appliedJobsIds.add(jobId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error applying to job: $e');
      return false;
    }
  }
}
