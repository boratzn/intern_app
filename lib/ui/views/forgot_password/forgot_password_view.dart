import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_viewmodel.dart';
import 'forgot_password_view.form.dart';

@FormView(fields: [FormTextField(name: 'email')])
class ForgotPasswordView extends StackedView<ForgotPasswordViewModel>
    with $ForgotPasswordView {
  const ForgotPasswordView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Şifre Sıfırlama',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Şifremi Unuttum 🔑',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 8),
              Text(
                    'Kayıtlı e-posta adresinizi girin, şifre sıfırlama bağlantısı gönderelim.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF71717A),
                    ),
                  )
                  .animate()
                  .fade(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 40),

              _buildTextField(
                    'E-posta',
                    Icons.email_outlined,
                    false,
                    emailController,
                  )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slideX(begin: 0.1, end: 0),

              const SizedBox(height: 40),

              SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Hero(
                      tag: 'auth_button',
                      child: ElevatedButton(
                        onPressed: viewModel.isBusy
                            ? null
                            : () {
                                viewModel.resetPassword(emailController.text);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: viewModel.isBusy
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Sıfırlama Bağlantısı Gönder',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  )
                  .animate()
                  .fade(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFFA1A1AA)),
          prefixIcon: Icon(icon, color: const Color(0xFFA1A1AA)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) =>
      ForgotPasswordViewModel();

  @override
  void onViewModelReady(ForgotPasswordViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(ForgotPasswordViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
