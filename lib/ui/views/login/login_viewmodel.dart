import 'package:stacked/stacked.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import '../../../services/notification_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_tops.dart';

class LoginViewModel extends FormViewModel {
  final _supabaseService = locator<SupabaseService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _notificationService = locator<NotificationService>();

  bool _isStudent = true;
  bool get isStudent => _isStudent;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  void setRole(bool isStudent) {
    _isStudent = isStudent;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void navigateToRegister() {
    _navigationService.navigateTo(Routes.registerView);
  }

  void navigateToForgotPassword() {
    _navigationService.navigateTo(Routes.forgotPasswordView);
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;

    setBusy(true);
    try {
      final response = await _supabaseService.signIn(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user != null) {
        // Register user in OneSignal for targeted push notifications
        _notificationService.loginUser(user.id);

        // Save remember_me preference
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', _rememberMe);

        // Read the is_student flag stored during registration
        final isStudentFromMetadata = user.userMetadata?['is_student'] as bool?;

        if (isStudentFromMetadata == null) {
          // No metadata — old account or OAuth; route based on selection
          if (_isStudent) {
            AppTops.studentProfile = await _supabaseService.getStudentProfile();
            _navigationService.clearStackAndShow(Routes.studentMainView);
          } else {
            AppTops.companyProfile = await _supabaseService.getCompanyProfile();
            _navigationService.clearStackAndShow(Routes.companyMainView);
          }
          return;
        }

        // Check if selected role matches registered role
        if (_isStudent && !isStudentFromMetadata) {
          // Selected "Öğrenci" but account is a company
          await _supabaseService.signOut();
          _dialogService.showDialog(
            title: 'Yanlış Rol',
            description:
                'Bu hesap bir şirket hesabıdır. Lütfen "Şirket" seçeneğini seçerek giriş yapın.',
          );
          return;
        }

        if (!_isStudent && isStudentFromMetadata) {
          // Selected "Şirket" but account is a student
          await _supabaseService.signOut();
          _dialogService.showDialog(
            title: 'Yanlış Rol',
            description:
                'Bu hesap bir öğrenci hesabıdır. Lütfen "Öğrenci" seçeneğini seçerek giriş yapın.',
          );
          return;
        }

        // Roles match — navigate
        if (isStudentFromMetadata) {
          AppTops.studentProfile = await _supabaseService.getStudentProfile();
          _navigationService.clearStackAndShow(Routes.studentMainView);
        } else {
          AppTops.companyProfile = await _supabaseService.getCompanyProfile();
          _navigationService.clearStackAndShow(Routes.companyMainView);
        }
      }
    } catch (e) {
      _dialogService.showDialog(
        title: 'Giriş Hatası',
        description: e.toString(),
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> signInWithGoogle() => _signInWithOAuth(OAuthProvider.google);
  Future<void> signInWithGitHub() => _signInWithOAuth(OAuthProvider.github);
  Future<void> signInWithApple() => _signInWithOAuth(OAuthProvider.apple);

  Future<void> _signInWithOAuth(OAuthProvider provider) async {
    setBusy(true);
    try {
      await _supabaseService.signInWithOAuth(provider);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
    } catch (e) {
      _dialogService.showDialog(
        title: 'Giriş Hatası',
        description: e.toString(),
      );
    } finally {
      setBusy(false);
    }
  }
}
