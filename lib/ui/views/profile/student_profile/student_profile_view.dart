import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'student_profile_viewmodel.dart';
import 'student_profile_view.form.dart';

@FormView(
  fields: [
    FormTextField(name: 'firstName'),
    FormTextField(name: 'lastName'),
    FormTextField(name: 'university'),
    FormTextField(name: 'department'),
    FormTextField(name: 'phone'),
    FormTextField(name: 'linkedin'),
    FormTextField(name: 'github'),
    FormTextField(name: 'location'),
    FormTextField(name: 'bio'),
    FormTextField(name: 'gradeYear'),
    FormTextField(name: 'gpa'),
    FormTextField(name: 'portfolio'),
    FormTextField(name: 'skills'),
  ],
)
class StudentProfileView extends StackedView<StudentProfileViewModel>
    with $StudentProfileView {
  const StudentProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StudentProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Öğrenci Profili',
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
          IconButton(onPressed: viewModel.signOut, icon: Icon(Icons.logout)),
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
                          Icons.person,
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
                title: 'Kişisel Bilgiler',
                isEditing: viewModel.isEditingPersonal,
                onEditToggle: viewModel.togglePersonal,
                children: [
                  if (viewModel.isEditingPersonal) ...[
                    _buildTextField(
                      firstNameController,
                      'Ad',
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      lastNameController,
                      'Soyad',
                      Icons.person_outline,
                    ),
                  ] else ...[
                    _buildInfoRow(
                      'Ad',
                      firstNameController.text.isNotEmpty
                          ? firstNameController.text
                          : 'Belirtilmemiş',
                      Icons.person_outline,
                    ),
                    _buildInfoRow(
                      'Soyad',
                      lastNameController.text.isNotEmpty
                          ? lastNameController.text
                          : 'Belirtilmemiş',
                      Icons.person_outline,
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'Eğitim Bilgileri',
                isEditing: viewModel.isEditingEducation,
                onEditToggle: viewModel.toggleEducation,
                children: [
                  if (viewModel.isEditingEducation) ...[
                    _buildTextField(
                      universityController,
                      'Üniversite',
                      Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      departmentController,
                      'Bölüm',
                      Icons.book_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      gradeYearController,
                      'Sınıf (Örn. 3. Sınıf)',
                      Icons.stairs_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      gpaController,
                      'Not Ortalaması (Örn. 3.50)',
                      Icons.score_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ] else ...[
                    _buildInfoRow(
                      'Üniversite',
                      universityController.text.isNotEmpty
                          ? universityController.text
                          : 'Belirtilmemiş',
                      Icons.school_outlined,
                    ),
                    _buildInfoRow(
                      'Bölüm',
                      departmentController.text.isNotEmpty
                          ? departmentController.text
                          : 'Belirtilmemiş',
                      Icons.book_outlined,
                    ),
                    _buildInfoRow(
                      'Sınıf',
                      gradeYearController.text.isNotEmpty
                          ? gradeYearController.text
                          : 'Belirtilmemiş',
                      Icons.stairs_outlined,
                    ),
                    _buildInfoRow(
                      'Not Ortalaması',
                      gpaController.text.isNotEmpty
                          ? gpaController.text
                          : 'Belirtilmemiş',
                      Icons.score_outlined,
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'İletişim & Sosyal Medya',
                isEditing: viewModel.isEditingContact,
                onEditToggle: viewModel.toggleContact,
                children: [
                  if (viewModel.isEditingContact) ...[
                    _buildTextField(
                      phoneController,
                      'Telefon',
                      Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      locationController,
                      'Şehir/Ülke',
                      Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      linkedinController,
                      'LinkedIn Profil URL',
                      Icons.link_outlined,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      githubController,
                      'GitHub Profil URL',
                      Icons.code_outlined,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      portfolioController,
                      'Portfolyo URL',
                      Icons.web_outlined,
                      keyboardType: TextInputType.url,
                    ),
                  ] else ...[
                    _buildInfoRow(
                      'Telefon',
                      phoneController.text.isNotEmpty
                          ? phoneController.text
                          : 'Belirtilmemiş',
                      Icons.phone_outlined,
                    ),
                    _buildInfoRow(
                      'Konum',
                      locationController.text.isNotEmpty
                          ? locationController.text
                          : 'Belirtilmemiş',
                      Icons.location_on_outlined,
                    ),
                    _buildInfoRow(
                      'LinkedIn',
                      linkedinController.text.isNotEmpty
                          ? linkedinController.text
                          : 'Belirtilmemiş',
                      Icons.link_outlined,
                    ),
                    _buildInfoRow(
                      'GitHub',
                      githubController.text.isNotEmpty
                          ? githubController.text
                          : 'Belirtilmemiş',
                      Icons.code_outlined,
                    ),
                    _buildInfoRow(
                      'Portfolyo',
                      portfolioController.text.isNotEmpty
                          ? portfolioController.text
                          : 'Belirtilmemiş',
                      Icons.web_outlined,
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'Hakkımda / Ön Yazı',
                isEditing: viewModel.isEditingAbout,
                onEditToggle: viewModel.toggleAbout,
                children: [
                  if (viewModel.isEditingAbout) ...[
                    _buildTextField(
                      bioController,
                      'Hakkımda',
                      Icons.info_outline,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      skillsController,
                      'Yetenekler (Virgülle ayırın Örn: Flutter,Dart,Firebase)',
                      Icons.star_outline,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Staj Arıyorum',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value: viewModel.isSeekingInternship,
                          onChanged: viewModel.toggleSeekingInternship,
                          thumbColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) => states.contains(WidgetState.selected)
                                ? const Color(0xFF4F46E5)
                                : null,
                          ),
                          trackColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) => states.contains(WidgetState.selected)
                                ? const Color(0xFF4F46E5).withAlpha(80)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      bioController.text.isNotEmpty
                          ? bioController.text
                          : 'Henüz bir ön yazı veya hakkımda bilgisi eklenmedi.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Yetenekler',
                      skillsController.text.isNotEmpty
                          ? skillsController.text
                          : 'Belirtilmemiş',
                      Icons.star_outline,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          viewModel.isSeekingInternship
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: viewModel.isSeekingInternship
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          viewModel.isSeekingInternship
                              ? 'Aktif olarak staj arıyor'
                              : 'Şu an staj aramıyor',
                          style: GoogleFonts.inter(
                            color: viewModel.isSeekingInternship
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              _buildSection(
                title: 'Özgeçmiş (CV)',
                children: [
                  if (viewModel.hasCv)
                    _buildCvDisplayCard(viewModel)
                  else
                    _buildCvUploadSection(viewModel),
                ],
              ),

              const SizedBox(height: 32),

              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: OutlinedButton.icon(
              //     onPressed: viewModel.isBusy ? null : viewModel.signOut,
              //     icon: const Icon(Icons.logout, color: Colors.red),
              //     label: Text(
              //       'Çıkış Yap',
              //       style: GoogleFonts.inter(
              //         fontSize: 18,
              //         color: Colors.red,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     style: OutlinedButton.styleFrom(
              //       side: const BorderSide(color: Colors.red),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 32),
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

  Widget _buildCvUploadSection(StudentProfileViewModel viewModel) {
    return InkWell(
      onTap: viewModel.pickCv,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.5),
            style: BorderStyle.none,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.upload_file, color: Color(0xFF4F46E5), size: 40),
            const SizedBox(height: 12),
            Text(
              'PDF formatında CV yükle',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Maksimum dosya boyutu: 5MB',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCvDisplayCard(StudentProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Özgeçmiş',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'CV.pdf',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: viewModel.removeCv,
          ),
          ElevatedButton(
            onPressed: viewModel.viewCv,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Görüntüle',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
  StudentProfileViewModel viewModelBuilder(BuildContext context) =>
      StudentProfileViewModel();

  @override
  void onViewModelReady(StudentProfileViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(StudentProfileViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }
}
