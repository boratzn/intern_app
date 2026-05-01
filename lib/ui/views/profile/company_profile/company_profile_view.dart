import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'company_profile_viewmodel.dart';
import 'company_profile_view.form.dart';

@FormView(
  fields: [
    FormTextField(name: 'companyName'),
    FormTextField(name: 'industry'),
    FormTextField(name: 'website'),
    FormTextField(name: 'contactPerson'),
    FormTextField(name: 'about'),
    FormTextField(name: 'employeeCount'),
    FormTextField(name: 'linkedinUrl'),
    FormTextField(name: 'city'),
    FormTextField(name: 'email'),
  ],
)
class CompanyProfileView extends StackedView<CompanyProfileViewModel>
    with $CompanyProfileView {
  const CompanyProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CompanyProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Şirket Profili',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (viewModel.anyEditing)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: viewModel.isBusy
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: viewModel.saveProfile,
                      icon: const Icon(Icons.check, color: Color(0xFF4F46E5)),
                      label: Text(
                        'Kaydet',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                    ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: viewModel.pickAvatar,
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFE0E7FF),
                  backgroundImage:
                      viewModel.avatarUrl != null &&
                          viewModel.avatarUrl!.isNotEmpty
                      ? NetworkImage(viewModel.avatarUrl!)
                      : null,
                  child:
                      viewModel.avatarUrl == null ||
                          viewModel.avatarUrl!.isEmpty
                      ? const Icon(
                          Icons.business,
                          size: 50,
                          color: Color(0xFF4F46E5),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.userEmail,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              _buildSection(
                title: 'Genel Bilgiler',
                isEditing: viewModel.isEditingGeneral,
                onEditToggle: viewModel.toggleGeneral,
                children: [
                  if (viewModel.isEditingGeneral) ...[
                    _buildTextField(
                      companyNameController,
                      'Şirket Adı',
                      Icons.business_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      industryController,
                      'Sektör',
                      Icons.work_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      cityController,
                      'Şehir',
                      Icons.location_city_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      employeeCountController,
                      'Çalışan Sayısı',
                      Icons.people_outline,
                      keyboardType: TextInputType.number,
                    ),
                  ] else ...[
                    _buildInfoRow(
                      'Şirket Adı',
                      companyNameController.text.isNotEmpty
                          ? companyNameController.text
                          : 'Belirtilmemiş',
                      Icons.business_outlined,
                    ),
                    _buildInfoRow(
                      'Sektör',
                      industryController.text.isNotEmpty
                          ? industryController.text
                          : 'Belirtilmemiş',
                      Icons.work_outline,
                    ),
                    _buildInfoRow(
                      'Şehir',
                      cityController.text.isNotEmpty
                          ? cityController.text
                          : 'Belirtilmemiş',
                      Icons.location_city_outlined,
                    ),
                    _buildInfoRow(
                      'Çalışan Sayısı',
                      employeeCountController.text.isNotEmpty
                          ? employeeCountController.text
                          : 'Belirtilmemiş',
                      Icons.people_outline,
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'İletişim Bilgileri',
                isEditing: viewModel.isEditingContact,
                onEditToggle: viewModel.toggleContact,
                children: [
                  if (viewModel.isEditingContact) ...[
                    _buildTextField(
                      websiteController,
                      'Web Sitesi',
                      Icons.language_outlined,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      contactPersonController,
                      'Yetkili Kişi',
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      emailController,
                      'E-posta',
                      Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      linkedinUrlController,
                      'LinkedIn URL',
                      Icons.link_outlined,
                      keyboardType: TextInputType.url,
                    ),
                  ] else ...[
                    _buildInfoRow(
                      'Web Sitesi',
                      websiteController.text.isNotEmpty
                          ? websiteController.text
                          : 'Belirtilmemiş',
                      Icons.language_outlined,
                    ),
                    _buildInfoRow(
                      'Yetkili Kişi',
                      contactPersonController.text.isNotEmpty
                          ? contactPersonController.text
                          : 'Belirtilmemiş',
                      Icons.person_outline,
                    ),
                    _buildInfoRow(
                      'E-posta',
                      emailController.text.isNotEmpty
                          ? emailController.text
                          : 'Belirtilmemiş',
                      Icons.email_outlined,
                    ),
                    _buildInfoRow(
                      'LinkedIn',
                      linkedinUrlController.text.isNotEmpty
                          ? linkedinUrlController.text
                          : 'Belirtilmemiş',
                      Icons.link_outlined,
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'Şirket Hakkında',
                isEditing: viewModel.isEditingAbout,
                onEditToggle: viewModel.toggleAbout,
                children: [
                  if (viewModel.isEditingAbout) ...[
                    _buildTextField(
                      aboutController,
                      'Şirket Hakkında',
                      Icons.info_outline,
                      maxLines: 4,
                    ),
                  ] else ...[
                    Text(
                      aboutController.text.isNotEmpty
                          ? aboutController.text
                          : 'Henüz şirket hakkında bir bilgi eklenmedi.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: viewModel.isBusy ? null : viewModel.signOut,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    'Çıkış Yap',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    bool? isEditing,
    VoidCallback? onEditToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (isEditing != null && onEditToggle != null)
                IconButton(
                  icon: Icon(isEditing ? Icons.close : Icons.edit_outlined),
                  onPressed: onEditToggle,
                  color: const Color(0xFF4F46E5),
                ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
        ),
      ),
    );
  }

  @override
  CompanyProfileViewModel viewModelBuilder(BuildContext context) =>
      CompanyProfileViewModel();

  @override
  void onViewModelReady(CompanyProfileViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(CompanyProfileViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }
}
