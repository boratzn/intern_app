import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../services/supabase_service.dart';
import '../../../../services/notification_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.router.dart';
import 'company_profile_view.form.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CompanyProfileViewModel extends FormViewModel with $CompanyProfileView {
  final _supabaseService = locator<SupabaseService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _notificationService = locator<NotificationService>();
  final ImagePicker _imagePicker = ImagePicker();

  String get userEmail =>
      _supabaseService.currentUser?.email ?? 'Şirket Email\'i';

  bool _isEditingGeneral = false;
  bool get isEditingGeneral => _isEditingGeneral;

  bool _isEditingContact = false;
  bool get isEditingContact => _isEditingContact;

  bool _isEditingAbout = false;
  bool get isEditingAbout => _isEditingAbout;

  bool get anyEditing =>
      _isEditingGeneral || _isEditingContact || _isEditingAbout;

  String? _avatarUrl;
  String? get avatarUrl => _avatarUrl;

  Future<void> init() async {
    setBusy(true);
    try {
      final profile = await _supabaseService.getCompanyProfile();
      if (profile != null) {
        companyNameValue = profile.companyName;
        industryValue = profile.sector;
        employeeCountValue = profile.companySize;
        websiteValue = profile.website;
        contactPersonValue = profile.contactPerson;
        aboutValue = profile.description;
        linkedinUrlValue = profile.linkedinUrl ?? '';
        cityValue = profile.city ?? '';
        emailValue = profile.email ?? '';
        _avatarUrl = profile.logoUrl;
      }
    } catch (e) {
      // Error is caught but we just proceed if profile is null
    } finally {
      setBusy(false);
    }
  }

  Future<void> pickAvatar() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      setBusy(true);
      try {
        final file = File(image.path);
        final userId = _supabaseService.currentUser?.id;
        if (userId == null) throw Exception('Kullanıcı bulunamadı.');

        final fileExt = image.path.split('.').last;
        final fileName =
            '$userId.${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        final url = await _supabaseService.uploadFile(
          bucketName: 'avatars',
          path: fileName,
          fileData: file,
        );

        if (url != null) {
          _avatarUrl = url;
          // Quickly save the profile to keep the url in DB
          await _supabaseService.updateCompanyProfile({'logo_url': url});
          _dialogService.showDialog(
            title: 'Başarılı',
            description: 'Profil fotoğrafınız güncellendi.',
          );
        }
      } catch (e) {
        _dialogService.showDialog(
          title: 'Hata',
          description: 'Fotoğraf yüklenirken bir sorun oluştu: ${e.toString()}',
        );
      } finally {
        setBusy(false);
        notifyListeners();
      }
    }
  }

  void toggleGeneral() {
    _isEditingGeneral = !_isEditingGeneral;
    notifyListeners();
  }

  void toggleContact() {
    _isEditingContact = !_isEditingContact;
    notifyListeners();
  }

  void toggleAbout() {
    _isEditingAbout = !_isEditingAbout;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    setBusy(true);
    try {
      // Map form fields to DB columns
      final data = {
        'company_name': companyNameValue,
        'sector': industryValue,
        'company_size': employeeCountValue,
        'website': websiteValue,
        'contact_person': contactPersonValue,
        'description': aboutValue,
        'linkedin_url': linkedinUrlValue,
        'city': cityValue,
        'email': emailValue,
      };

      await _supabaseService.updateCompanyProfile(data);

      // Close all editing modes
      _isEditingGeneral = false;
      _isEditingContact = false;
      _isEditingAbout = false;

      _dialogService.showDialog(
        title: 'Başarılı',
        description: 'Şirket bilgileri başarıyla kaydedildi.',
      );
    } catch (e) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Kaydedilirken bir hata oluştu: ${e.toString()}',
      );
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    setBusy(true);
    try {
      _notificationService.logoutUser();
      await _supabaseService.signOut();
      setBusy(false);
      _navigationService.clearStackAndShow(Routes.loginView);
    } catch (e) {
      setBusy(false);
      _isEditingGeneral = false;
      _isEditingContact = false;
      _isEditingAbout = false;
      notifyListeners();

      _dialogService.showDialog(
        title: 'Çıkış Hatası',
        description: e.toString(),
      );
    }
  }

  @override
  void setFormStatus() {
    // This correctly overrides FormStateHelper.setFormStatus
  }
}
