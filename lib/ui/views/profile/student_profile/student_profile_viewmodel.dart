import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../services/supabase_service.dart';
import '../../../../services/notification_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'student_profile_view.form.dart';

class StudentProfileViewModel extends FormViewModel with $StudentProfileView {
  final _supabaseService = locator<SupabaseService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _notificationService = locator<NotificationService>();
  final ImagePicker _imagePicker = ImagePicker();

  String get userEmail =>
      _supabaseService.currentUser?.email ?? 'Öğrenci Email\'i';

  bool _isEditingPersonal = false;
  bool get isEditingPersonal => _isEditingPersonal;

  bool _isEditingEducation = false;
  bool get isEditingEducation => _isEditingEducation;

  bool _isEditingContact = false;
  bool get isEditingContact => _isEditingContact;

  bool _isEditingAbout = false;
  bool get isEditingAbout => _isEditingAbout;

  bool get anyEditing =>
      _isEditingPersonal ||
      _isEditingEducation ||
      _isEditingContact ||
      _isEditingAbout;

  String? _cvUrl;
  String? get cvPath => _cvUrl;
  bool get hasCv => _cvUrl != null && _cvUrl!.isNotEmpty;

  String? _avatarUrl;
  String? get avatarUrl => _avatarUrl;

  bool _isSeekingInternship = true;
  bool get isSeekingInternship => _isSeekingInternship;

  @override
  void setFormStatus() {}

  void toggleSeekingInternship(bool value) {
    _isSeekingInternship = value;
    notifyListeners();
  }

  void init() async {
    setBusy(true);
    try {
      final profile = await _supabaseService.getStudentProfile();
      if (profile != null) {
        // Map data to form fields
        firstNameValue = profile.firstName ?? '';
        lastNameValue = profile.lastName ?? '';
        universityValue = profile.university ?? '';
        departmentValue = profile.department ?? '';
        gradeYearValue = profile.gradeYear ?? '';
        final double? gpa = profile.gpa;
        gpaValue = gpa != null ? gpa.toStringAsFixed(2) : '';
        phoneValue = profile.phone ?? '';
        locationValue = profile.city ?? '';
        bioValue = profile.about ?? '';
        linkedinValue = profile.linkedinUrl ?? '';
        githubValue = profile.githubUrl ?? '';
        portfolioValue = profile.portfolioUrl ?? '';

        if (profile.skills != null) {
          skillsValue = profile.skills!.join(', ');
        } else {
          skillsValue = '';
        }

        _isSeekingInternship = profile.isSeekingInternship;
        _cvUrl = profile.cvUrl;
        _avatarUrl = profile.avatarUrl;
      }
    } catch (e) {
      // Ignore if no profile found
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
          await _supabaseService.updateStudentProfile({'avatar_url': url});
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

  void togglePersonal() {
    _isEditingPersonal = !_isEditingPersonal;
    notifyListeners();
  }

  void toggleEducation() {
    _isEditingEducation = !_isEditingEducation;
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

  Future<void> pickCv() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setBusy(true);
      try {
        final file = File(result.files.single.path!);
        final userId = _supabaseService.currentUser?.id;
        if (userId == null) throw Exception('Kullanıcı bulunamadı.');

        final fileName = '$userId.${DateTime.now().millisecondsSinceEpoch}.pdf';

        final url = await _supabaseService.uploadFile(
          bucketName: 'cvs',
          path: fileName,
          fileData: file,
        );

        if (url != null) {
          _cvUrl = url;
          await _supabaseService.updateStudentProfile({'cv_url': url});
          _dialogService.showDialog(
            title: 'Tebrikler 🎉',
            description:
                'Özgeçmişiniz (CV) başarıyla sisteme yüklendi ve profilinize eklendi.',
            buttonTitle: 'Harika',
          );
        }
      } catch (e) {
        _dialogService.showDialog(
          title: 'Hata',
          description: 'CV yüklenirken bir sorun oluştu: ${e.toString()}',
        );
        debugPrint(e.toString());
      } finally {
        setBusy(false);
        notifyListeners();
      }
    }
  }

  void viewCv() {
    if (_cvUrl != null) {
      _navigationService.navigateToCvViewerView(pdfPath: _cvUrl!);
    }
  }

  void removeCv() async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'CV Silme Onayı',
      description:
          'Mevcut özgeçmişinizi sistemden silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      confirmationTitle: 'Evet, Sil',
      cancelTitle: 'İptal',
    );

    if (response?.confirmed != true) return;

    setBusy(true);
    _cvUrl = null;
    try {
      await _supabaseService.updateStudentProfile({'cv_url': null});
      _dialogService.showDialog(
        title: 'Başarılı',
        description: 'Özgeçmişiniz başarıyla silindi.',
      );
    } catch (e) {
      // ignore
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> saveProfile() async {
    setBusy(true);
    try {
      final List<String> skillsList = (skillsValue ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final data = {
        'first_name': firstNameValue,
        'last_name': lastNameValue,
        'university': universityValue,
        'department': departmentValue,
        'grade_year': gradeYearValue,
        'gpa': double.tryParse(gpaValue ?? ''),
        'phone': phoneValue,
        'city': locationValue,
        'about': bioValue,
        'skills': skillsList,
        'linkedin_url': linkedinValue,
        'github_url': githubValue,
        'portfolio_url': portfolioValue,
        'is_seeking_internship': _isSeekingInternship,
        'cv_url': _cvUrl,
      };

      await _supabaseService.updateStudentProfile(data);

      _isEditingPersonal = false;
      _isEditingEducation = false;
      _isEditingContact = false;
      _isEditingAbout = false;

      _dialogService.showDialog(
        title: 'Başarılı',
        description: 'Profil bilgileriniz kaydedildi.',
      );
    } catch (e) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Profil kaydedilirken bir hata oluştu: ${e.toString()}',
      );
    } finally {
      setBusy(false);
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
      _isEditingPersonal = false;
      _isEditingEducation = false;
      _isEditingContact = false;
      _isEditingAbout = false;
      notifyListeners();

      _dialogService.showDialog(
        title: 'Çıkış Hatası',
        description: e.toString(),
      );
    }
  }
}
