import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'register_viewmodel.dart';
import 'register_view.form.dart';

@FormView(
  fields: [
    FormTextField(name: 'email'),
    FormTextField(name: 'password'),
    FormTextField(name: 'confirmPassword'),
  ],
)
class RegisterView extends StackedView<RegisterViewModel> with $RegisterView {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            'Hesap Oluştur',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aramıza Katıl 👋',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                      'Sana uygun rolü seçerek hemen kayıt ol.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF71717A),
                      ),
                    )
                    .animate()
                    .fade(duration: 500.ms, delay: 100.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 40),

                // Role Selector
                Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0D000000),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => viewModel.setRole(true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: viewModel.isStudent
                                      ? const Color(0xFF4F46E5)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Öğrenci',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: viewModel.isStudent
                                          ? Colors.white
                                          : const Color(0xFF71717A),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => viewModel.setRole(false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: !viewModel.isStudent
                                      ? const Color(0xFF4F46E5)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Şirket',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: !viewModel.isStudent
                                          ? Colors.white
                                          : const Color(0xFF71717A),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fade(duration: 500.ms, delay: 200.ms)
                    .scale(begin: const Offset(0.95, 0.95)),

                const SizedBox(height: 40),

                _buildTextField(
                      'E-posta',
                      Icons.email_outlined,
                      false,
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                    )
                    .animate()
                    .fade(duration: 500.ms, delay: 300.ms)
                    .slideX(begin: 0.1, end: 0),
                const SizedBox(height: 20),
                _buildTextField(
                      'Şifre',
                      Icons.lock_outline,
                      true,
                      passwordController,
                    )
                    .animate()
                    .fade(duration: 500.ms, delay: 400.ms)
                    .slideX(begin: 0.1, end: 0),
                const SizedBox(height: 20),
                _buildTextField(
                      'Şifre Tekrar',
                      Icons.lock_outline,
                      true,
                      confirmPasswordController,
                    )
                    .animate()
                    .fade(duration: 500.ms, delay: 500.ms)
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
                                  viewModel.register(
                                    emailController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                  );
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
                                  'Kayıt Ol',
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
                    .fade(duration: 500.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE4E4E7))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'veya şununla devam et',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFFA1A1AA),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE4E4E7))),
                  ],
                ).animate().fade(duration: 500.ms, delay: 700.ms),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        label: 'Google',
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                        onTap: viewModel.signInWithGoogle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSocialButton(
                        label: 'GitHub',
                        icon: const Icon(
                          Icons.code,
                          size: 20,
                          color: Color(0xFF1A1A1A),
                        ),
                        onTap: viewModel.signInWithGitHub,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (Platform.isIOS) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          label: 'Apple',
                          icon: const Icon(
                            Icons.apple,
                            size: 22,
                            color: Color(0xFF1A1A1A),
                          ),
                          onTap: viewModel.signInWithApple,
                        ),
                      ),
                    ],
                  ],
                ).animate().fade(duration: 500.ms, delay: 800.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E4E7)),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF3F3F46),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    bool isPassword,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
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
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();

  @override
  void onViewModelReady(RegisterViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(RegisterViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
