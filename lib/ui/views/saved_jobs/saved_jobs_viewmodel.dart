import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/job_listing.dart';
import '../../../services/supabase_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SavedJobsViewModel extends BaseViewModel {
  final _supabaseService = locator<SupabaseService>();
  final _navigationService = locator<NavigationService>();

  List<JobListing> savedJobs = [];

  Future<void> init() async {
    await fetchSavedJobs();
  }

  Future<void> fetchSavedJobs() async {
    setBusy(true);
    try {
      savedJobs = await _supabaseService.getSavedJobs();
    } catch (e) {
      debugPrint('Error fetching saved jobs: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void navigateToJobDetail(JobListing job) {
    _navigationService.navigateToJobDetailView(job: job).then((_) {
      // Refetch when returning back, in case they unfavorited the job
      fetchSavedJobs();
    });
  }
}
