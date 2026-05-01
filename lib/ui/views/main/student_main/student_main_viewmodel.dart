import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../services/supabase_service.dart';

class StudentMainViewModel extends IndexTrackingViewModel {
  final _supabaseService = locator<SupabaseService>();

  void init() {
    // Eagerly fetch profile data in the background so it's ready
    // when the user navigates to the profile tab.
    getData();
  }

  Future<void> getData() async {
    Future.wait([
      _supabaseService.getStudentProfile(),
      _supabaseService.getAppliedJobsIds(),
    ]);
  }
}
