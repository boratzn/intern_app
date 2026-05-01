import 'package:intern_app/core/app_tops.dart';
import 'package:intern_app/core/models/category.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';

class CreateJobViewModel extends BaseViewModel {
  final _supabaseService = locator<SupabaseService>();

  // --- Form State ---
  String title = '';
  String location = '';
  String description = '';
  String requirements = '';
  String benefits = '';
  String internshipDuration = '3 Ay';
  String workType = 'Uzaktan';
  String compensationType = 'Ücretli';
  bool applicationDeadlineEnabled = false;
  DateTime? deadline;

  Category? selectedCategory;
  int? get categoryId => selectedCategory?.id;

  List<Category> get categories => AppTops.categories;

  final List<String> workTypes = ['Uzaktan', 'Yerinde', 'Hibrit'];
  final List<String> compensationTypes = ['Ücretli', 'Ücretsiz'];
  final List<String> durations = [
    '1 Ay',
    '2 Ay',
    '3 Ay',
    '4 Ay',
    '6 Ay',
    '1 Yıl',
  ];

  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    setBusy(true);
    await _supabaseService.getCategories();
    setBusy(false);
    notifyListeners();
  }

  void setCategory(Category category) {
    selectedCategory = category;
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
    internshipDuration = val;
    notifyListeners();
  }

  void toggleDeadline(bool val) {
    applicationDeadlineEnabled = val;
    notifyListeners();
  }

  void setDeadline(DateTime date) {
    deadline = date;
    notifyListeners();
  }

  Future<void> publishJob() async {
    if (title.isEmpty ||
        selectedCategory == null ||
        location.isEmpty ||
        description.isEmpty) {
      _errorMessage = 'Lütfen zorunlu alanları doldurun (*, işaretli).';
      notifyListeners();
      return;
    }

    _errorMessage = null;
    setBusy(true);
    try {
      await _supabaseService.createJobListing(
        title: title,
        department: selectedCategory!.categoryName,
        location: location,
        workType: workType,
        compensationType: compensationType,
        duration: internshipDuration,
        description: description,
        requirements: requirements,
        benefits: benefits,
        deadline: applicationDeadlineEnabled ? deadline : null,
        categoryId: categoryId,
      );
      _successMessage = 'İlan başarıyla yayınlandı!';
    } catch (e) {
      _errorMessage = 'İlan yayınlanırken hata oluştu: ${e.toString()}';
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetForm() {
    title = '';
    selectedCategory = null;
    location = '';
    description = '';
    requirements = '';
    benefits = '';
    internshipDuration = '3 Ay';
    workType = 'Uzaktan';
    compensationType = 'Ücretli';
    _successMessage = null;
    _errorMessage = null;
    applicationDeadlineEnabled = false;
    deadline = null;
    notifyListeners();
  }
}
