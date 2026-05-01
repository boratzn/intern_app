import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import '../company_dashboard/company_dashboard_viewmodel.dart';

class EditJobViewModel extends BaseViewModel {
  final _supabaseService = locator<SupabaseService>();

  final String jobId;
  String title;
  String location;
  String workType;
  String compensationType;
  String duration;
  String description;
  String requirements;
  String benefits;
  bool isActive;
  DateTime? deadline;
  bool hasDeadline;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _saved = false;
  bool get saved => _saved;

  static const List<String> workTypes = ['Uzaktan', 'Yerinde', 'Hibrit'];
  static const List<String> compensationTypes = ['Ücretli', 'Ücretsiz'];
  static const List<String> durations = [
    '1 Ay',
    '2 Ay',
    '3 Ay',
    '4 Ay',
    '6 Ay',
    '1 Yıl',
  ];

  EditJobViewModel(JobListing job)
      : jobId = job.id,
        title = job.title,
        location = job.location,
        workType = job.type.isEmpty ? 'Uzaktan' : job.type,
        compensationType =
            job.compensationType.isEmpty ? 'Ücretli' : job.compensationType,
        duration = job.duration.isEmpty ? '3 Ay' : job.duration,
        description = job.description,
        requirements = job.requirements,
        benefits = job.benefits,
        isActive = job.isActive,
        deadline = job.deadline,
        hasDeadline = job.deadline != null;

  void setIsActive(bool val) {
    isActive = val;
    notifyListeners();
  }

  void setLocation(String val) {
    location = val;
    notifyListeners();
  }

  void setWorkType(String val) {
    workType = val;
    notifyListeners();
  }

  void setCompensationType(String val) {
    compensationType = val;
    notifyListeners();
  }

  void setDuration(String val) {
    duration = val;
    notifyListeners();
  }

  void toggleDeadline(bool val) {
    hasDeadline = val;
    notifyListeners();
  }

  void setDeadline(DateTime date) {
    deadline = date;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> save() async {
    if (title.trim().isEmpty || location.isEmpty) {
      _errorMessage = 'Başlık ve konum zorunludur.';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    setBusy(true);
    try {
      await _supabaseService.updateJobListing(
        jobId: jobId,
        title: title.trim(),
        location: location,
        workType: workType,
        compensationType: compensationType,
        duration: duration,
        description: description,
        requirements: requirements,
        benefits: benefits,
        isActive: isActive,
        deadline: hasDeadline ? deadline : null,
      );
      _saved = true;
    } catch (e) {
      _errorMessage = 'Kaydetme sırasında hata oluştu: ${e.toString()}';
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }
}
