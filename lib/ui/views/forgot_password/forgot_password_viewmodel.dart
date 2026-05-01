import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../services/supabase_service.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends FormViewModel {
  final _supabaseService = locator<SupabaseService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      _dialogService.showDialog(
        title: 'Hata',
        description: 'Lütfen e-posta adresinizi girin.',
      );
      return;
    }

    setBusy(true);
    try {
      await _supabaseService.resetPassword(email);
      await _dialogService.showDialog(
        title: 'Başarılı',
        description:
            'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.',
      );
      _navigationService.back();
    } catch (e) {
      _dialogService.showDialog(title: 'Hata', description: e.toString());
    } finally {
      setBusy(false);
    }
  }
}
