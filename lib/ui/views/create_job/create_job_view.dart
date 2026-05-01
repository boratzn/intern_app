import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_app/core/models/category.dart';
import 'package:stacked/stacked.dart';

import 'create_job_viewmodel.dart';

const List<String> _provinces = [
  'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya',
  'Ankara', 'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir', 'Bartın',
  'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur',
  'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır',
  'Düzce', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir',
  'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Iğdır',
  'Isparta', 'İstanbul', 'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman',
  'Kars', 'Kastamonu', 'Kayseri', 'Kilis', 'Kırıkkale', 'Kırklareli',
  'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa',
  'Mardin', 'Mersin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu',
  'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas',
  'Şanlıurfa', 'Şırnak', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli',
  'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak',
];

class CreateJobView extends StackedView<CreateJobViewModel> {
  const CreateJobView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateJobViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.successMessage != null) {
      return _SuccessScreen(viewModel: viewModel);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F8),
        body: CustomScrollView(
          slivers: [
            // --- AppBar ---
            SliverAppBar(
              expandedHeight: 130,
              pinned: true,
              backgroundColor: const Color(0xFF4F46E5),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                title: Text(
                  'İlan Oluştur',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.work_outline,
                        color: Colors.white24,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ---------- Temel Bilgiler ----------
                  _SectionHeader(
                    icon: Icons.info_outline,
                    title: 'Temel Bilgiler',
                    delay: 0,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 50,
                    children: [
                      _InputField(
                        label: 'İlan Başlığı *',
                        hint: 'örn. Flutter Geliştirici Stajyer',
                        icon: Icons.title,
                        onChanged: (v) => viewModel.title = v,
                      ),
                      const _Divider(),
                      _DropdownField<Category>(
                        label: 'Departman / Kategori *',
                        icon: Icons.business_center_outlined,
                        hint: 'Kategori seçin',
                        value: viewModel.selectedCategory,
                        items: viewModel.categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.categoryName),
                              ),
                            )
                            .toList(),
                        onChanged: (c) {
                          if (c != null) viewModel.setCategory(c);
                        },
                      ),
                      const _Divider(),
                      _DropdownField<String>(
                        label: 'Konum *',
                        icon: Icons.location_on_outlined,
                        hint: 'İl seçin',
                        value: viewModel.location.isEmpty
                            ? null
                            : viewModel.location,
                        items: _provinces
                            .map(
                              (p) =>
                                  DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                        onChanged: (p) {
                          if (p != null) viewModel.setLocation(p);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ---------- Çalışma Koşulları ----------
                  _SectionHeader(
                    icon: Icons.tune_outlined,
                    title: 'Çalışma Koşulları',
                    delay: 100,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 150,
                    children: [
                      // Work Type
                      _LabeledRow(label: 'Çalışma Tipi'),
                      const SizedBox(height: 10),
                      _SegmentedPicker(
                        options: viewModel.workTypes,
                        selected: viewModel.workType,
                        onSelected: viewModel.setWorkType,
                        icons: const [
                          Icons.wifi_outlined,
                          Icons.apartment_outlined,
                          Icons.device_hub_outlined,
                        ],
                      ),
                      const _Divider(),

                      // Compensation
                      _LabeledRow(label: 'Ücret Durumu'),
                      const SizedBox(height: 10),
                      _TogglePicker(
                        options: viewModel.compensationTypes,
                        selected: viewModel.compensationType,
                        onSelected: viewModel.setCompensationType,
                        colors: const [Color(0xFF10B981), Color(0xFFEF4444)],
                      ),
                      const _Divider(),

                      // Duration
                      _LabeledRow(label: 'Staj Süresi'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: viewModel.durations.map((d) {
                          final isSelected = viewModel.internshipDuration == d;
                          return GestureDetector(
                            onTap: () => viewModel.setDuration(d),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFFF4F4F8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFFE4E4E7),
                                ),
                              ),
                              child: Text(
                                d,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF52525B),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ---------- İlan Detayları ----------
                  _SectionHeader(
                    icon: Icons.description_outlined,
                    title: 'İlan Detayları',
                    delay: 200,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 250,
                    children: [
                      _InputField(
                        label: 'İş Açıklaması *',
                        hint:
                            'Bu pozisyonda ne yapılacağını, günlük görevleri açıklayın...',
                        icon: Icons.article_outlined,
                        maxLines: 5,
                        onChanged: (v) => viewModel.description = v,
                      ),
                      const _Divider(),
                      _InputField(
                        label: 'Aranan Nitelikler',
                        hint:
                            'Gerekli beceriler, eğitim düzeyi, teknik bilgiler...',
                        icon: Icons.checklist_outlined,
                        maxLines: 4,
                        onChanged: (v) => viewModel.requirements = v,
                      ),
                      const _Divider(),
                      _InputField(
                        label: 'Kazanımlar & Yan Haklar',
                        hint:
                            'Stajyer ne kazanacak? Ulaşım, yemek, öğrenme fırsatları...',
                        icon: Icons.card_giftcard_outlined,
                        maxLines: 3,
                        onChanged: (v) => viewModel.benefits = v,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ---------- Son Başvuru Tarihi ----------
                  _SectionHeader(
                    icon: Icons.calendar_today_outlined,
                    title: 'Son Başvuru Tarihi',
                    delay: 300,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 350,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Son tarih belirle',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: viewModel.applicationDeadlineEnabled,
                            onChanged: viewModel.toggleDeadline,
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
                      if (viewModel.applicationDeadlineEnabled) ...[
                        const _Divider(),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 14),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              builder: (ctx, child) => Theme(
                                data: Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF4F46E5),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) viewModel.setDeadline(picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE4E4E7),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF4F46E5),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  viewModel.deadline != null
                                      ? '${viewModel.deadline!.day}.${viewModel.deadline!.month}.${viewModel.deadline!.year}'
                                      : 'Tarih seçin',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: viewModel.deadline != null
                                        ? const Color(0xFF1A1A2E)
                                        : const Color(0xFFA1A1AA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ---------- Error Banner ----------
                  if (viewModel.errorMessage != null)
                    Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withAlpha(15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withAlpha(80),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFFEF4444),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: viewModel.clearError,
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fade(duration: 300.ms)
                        .slideY(begin: -0.05, end: 0),

                  // ---------- Publish Button ----------
                  SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: viewModel.isBusy
                              ? null
                              : viewModel.publishJob,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            disabledBackgroundColor: const Color(
                              0xFF4F46E5,
                            ).withAlpha(120),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: viewModel.isBusy
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'İlanı Yayınla',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                      .animate(delay: 400.ms)
                      .fade(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(CreateJobViewModel viewModel) => viewModel.init();

  @override
  CreateJobViewModel viewModelBuilder(BuildContext context) =>
      CreateJobViewModel();
}

// -------------------------------------------------------
// Success Screen
// -------------------------------------------------------
class _SuccessScreen extends StatelessWidget {
  final CreateJobViewModel viewModel;
  const _SuccessScreen({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF10B981),
                  size: 56,
                ),
              ).animate().scale(
                begin: const Offset(0.5, 0.5),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),

              const SizedBox(height: 28),

              Text(
                'İlan Yayınlandı! 🎉',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ).animate(delay: 200.ms).fade(duration: 400.ms),

              const SizedBox(height: 10),

              Text(
                'İlanınız başarıyla yayınlandı.\nBaşvurular geldiğinde bildirim alacaksınız.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF71717A),
                  height: 1.6,
                ),
              ).animate(delay: 300.ms).fade(duration: 400.ms),

              const SizedBox(height: 40),

              SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: viewModel.resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Yeni İlan Oluştur',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fade(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// Reusable Helpers
// -------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int delay;
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        )
        .animate(delay: Duration(milliseconds: delay))
        .fade(duration: 350.ms)
        .slideX(begin: -0.05, end: 0);
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  final int delay;
  const _FormCard({required this.children, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fade(duration: 350.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: const Color(0xFF71717A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3F3F46),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFFA1A1AA),
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F8FC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4F46E5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: const Color(0xFF71717A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3F3F46),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: DropdownButton<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF71717A),
            ),
            hint: Text(
              hint,
              style: GoogleFonts.inter(
                color: const Color(0xFFA1A1AA),
                fontSize: 13,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledRow extends StatelessWidget {
  final String label;
  const _LabeledRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF3F3F46),
      ),
    );
  }
}

class _SegmentedPicker extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  final List<IconData> icons;

  const _SegmentedPicker({
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.asMap().entries.map((e) {
        final isSelected = e.value == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(e.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(
                right: e.key < options.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFFF4F4F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFFE4E4E7),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    icons[e.key],
                    size: 18,
                    color: isSelected ? Colors.white : const Color(0xFF71717A),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.value,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF52525B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TogglePicker extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  final List<Color> colors;

  const _TogglePicker({
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.asMap().entries.map((e) {
        final isSelected = e.value == selected;
        final color = colors[e.key];
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(e.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(
                right: e.key < options.length - 1 ? 10 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : const Color(0xFFF4F4F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFE4E4E7),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    size: 16,
                    color: isSelected ? Colors.white : color.withAlpha(150),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    e.value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF52525B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
    );
  }
}
