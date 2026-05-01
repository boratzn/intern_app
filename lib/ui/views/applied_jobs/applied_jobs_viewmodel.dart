import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'application_tracker_view.dart';

class AppliedJobsViewModel extends BaseViewModel {
  final _supabaseService = locator<SupabaseService>();

  List<Map<String, dynamic>> appliedJobs = [];

  Future<void> init() async {
    await fetchAppliedJobs();
  }

  Future<void> fetchAppliedJobs() async {
    setBusy(true);
    try {
      appliedJobs = await _supabaseService.getAppliedJobs();
    } catch (e) {
      debugPrint('Error fetching applied jobs: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void navigateToTracker(Map<String, dynamic> applicationData) {
    StackedService.navigatorKey?.currentState
        ?.push(
          MaterialPageRoute(
            builder: (context) =>
                ApplicationTrackerView(applicationData: applicationData),
          ),
        )
        .then((_) {
          fetchAppliedJobs();
        });
  }
}
