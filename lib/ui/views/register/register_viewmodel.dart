import 'package:stacked/stacked.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.router.dart';

class RegisterViewModel extends FormViewModel {
  final _supabaseService = locator<SupabaseService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  bool _isStudent = true;
  bool get isStudent => _isStudent;

  void setRole(bool isStudent) {
    _isStudent = isStudent;
    notifyListeners();
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Lütfen tüm alanları doldurun.',
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      _dialogService.showDialog(
        title: 'Geçersiz E-posta',
        description:
            'Lütfen geçerli bir e-posta adresi girin. (örn: isim@domain.com)',
      );
      return;
    }

    if (password != confirmPassword) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Şifreler eşleşmiyor.',
      );
      return;
    }

    if (password.length < 6) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Şifre en az 6 karakter olmalıdır.',
      );
      return;
    }

    setBusy(true);
    try {
      final response = await _supabaseService.signUp(
        email: email.trim(),
        password: password,
        isStudent: _isStudent,
      );
      // response.user is set even when email confirmation is required.
      // If session is null → email confirmation is pending.
      if (response.session != null) {
        // Confirmed immediately (email confirmation disabled)
        if (_isStudent) {
          _navigationService.clearStackAndShow(Routes.studentMainView);
        } else {
          _navigationService.clearStackAndShow(Routes.companyMainView);
        }
      } else if (response.user != null) {
        // Email confirmation required
        await _dialogService.showDialog(
          title: 'Kayıt Başarılı 🎉',
          description:
              'Hesabınız oluşturuldu. Lütfen e-posta adresinize gönderilen doğrulama bağlantısına tıklayın, ardından giriş yapın.',
        );
        _navigationService.back(); // Go back to login
      }
    } catch (e) {
      _dialogService.showDialog(
        title: 'Kayıt Hatası',
        description: _translateError(e.toString()),
      );
    } finally {
      setBusy(false);
    }
  }

  String _translateError(String error) {
    final lower = error.toLowerCase();
    if (lower.contains('email') && lower.contains('invalid')) {
      return 'Geçersiz e-posta adresi. Lütfen doğru bir e-posta girin.';
    }
    if (lower.contains('already registered') ||
        lower.contains('already exists') ||
        lower.contains('user already')) {
      return 'Bu e-posta adresiyle zaten bir hesap mevcut. Lütfen giriş yapın.';
    }
    if (lower.contains('password') &&
        (lower.contains('weak') || lower.contains('short'))) {
      return 'Şifre çok kısa veya zayıf. En az 6 karakter kullanın.';
    }
    if (lower.contains('network') || lower.contains('connection')) {
      return 'Bağlantı hatası. İnternet bağlantınızı kontrol edin.';
    }
    if (lower.contains('rate limit') ||
        lower.contains('too many') ||
        lower.contains('email rate')) {
      return 'Çok fazla kayıt denemesi yapıldı. Lütfen 1 saat bekleyip tekrar deneyin veya Supabase panelinden e-posta doğrulamasını kapatın.';
    }
    // Show raw error for easier debugging
    return 'Hata: $error';
  }

  Future<void> signInWithGoogle() => _signInWithOAuth(OAuthProvider.google);
  Future<void> signInWithGitHub() => _signInWithOAuth(OAuthProvider.github);
  Future<void> signInWithApple() => _signInWithOAuth(OAuthProvider.apple);

  Future<void> _signInWithOAuth(OAuthProvider provider) async {
    setBusy(true);
    try {
      await _supabaseService.signInWithOAuth(provider);
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
