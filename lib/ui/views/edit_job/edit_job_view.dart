import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../company_dashboard/company_dashboard_viewmodel.dart';
import 'edit_job_viewmodel.dart';

const List<String> _kProvinces = [
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

class EditJobView extends StackedView<EditJobViewModel> {
  final JobListing job;
  const EditJobView({super.key, required this.job});

  @override
  EditJobViewModel viewModelBuilder(BuildContext context) =>
      EditJobViewModel(job);

  @override
  void onViewModelReady(EditJobViewModel viewModel) {}

  @override
  Widget builder(
    BuildContext context,
    EditJobViewModel viewModel,
    Widget? child,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (viewModel.saved) {
        Navigator.of(context).pop(true);
        return;
      }
      if (viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage!,
              style: GoogleFonts.inter(fontSize: 13),
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        viewModel.clearError();
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F8),
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context, viewModel),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ---- Yayın Durumu ----
                  _ActiveToggleCard(viewModel: viewModel),
                  const SizedBox(height: 22),

                  // ---- Temel Bilgiler ----
                  _EditSectionHeader(
                    icon: Icons.info_outline_rounded,
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
                        icon: Icons.title_rounded,
                        initialValue: viewModel.title,
                        onChanged: (v) => viewModel.title = v,
                      ),
                      const _FieldDivider(),
                      _DropdownField<String>(
                        label: 'Konum *',
                        icon: Icons.location_on_outlined,
                        hint: 'İl seçin',
                        value: viewModel.location.isEmpty
                            ? null
                            : viewModel.location,
                        items: _kProvinces
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (p) {
                          if (p != null) viewModel.setLocation(p);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ---- Çalışma Koşulları ----
                  _EditSectionHeader(
                    icon: Icons.tune_outlined,
                    title: 'Çalışma Koşulları',
                    delay: 80,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 120,
                    children: [
                      _LabelRow(label: 'Çalışma Tipi'),
                      const SizedBox(height: 10),
                      _SegmentedPicker(
                        options: EditJobViewModel.workTypes,
                        selected: viewModel.workType,
                        icons: const [
                          Icons.wifi_outlined,
                          Icons.apartment_outlined,
                          Icons.device_hub_outlined,
                        ],
                        onSelected: viewModel.setWorkType,
                      ),
                      const _FieldDivider(),
                      _LabelRow(label: 'Ücret Durumu'),
                      const SizedBox(height: 10),
                      _TogglePicker(
                        options: EditJobViewModel.compensationTypes,
                        selected: viewModel.compensationType,
                        colors: const [Color(0xFF10B981), Color(0xFFEF4444)],
                        onSelected: viewModel.setCompensationType,
                      ),
                      const _FieldDivider(),
                      _DropdownField<String>(
                        label: 'Staj Süresi',
                        icon: Icons.calendar_month_outlined,
                        hint: 'Süre seçin',
                        value: viewModel.duration.isEmpty
                            ? null
                            : viewModel.duration,
                        items: EditJobViewModel.durations
                            .map((d) =>
                                DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (d) {
                          if (d != null) viewModel.setDuration(d);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ---- Detaylar ----
                  _EditSectionHeader(
                    icon: Icons.description_outlined,
                    title: 'İlan Detayları',
                    delay: 160,
                  ),
                  const SizedBox(height: 12),
                  _FormCard(
                    delay: 200,
                    children: [
                      _MultilineField(
                        label: 'İlan Açıklaması',
                        hint: 'Pozisyon hakkında genel bilgi...',
                        icon: Icons.article_outlined,
                        initialValue: viewModel.description,
                        onChanged: (v) => viewModel.description = v,
                      ),
                      const _FieldDivider(),
                      _MultilineField(
                        label: 'Aranan Nitelikler',
                        hint: 'Gerekli beceri ve deneyimler...',
                        icon: Icons.checklist_rounded,
                        initialValue: viewModel.requirements,
                        onChanged: (v) => viewModel.requirements = v,
                      ),
                      const _FieldDivider(),
                      _MultilineField(
                        label: 'Yan Haklar & Avantajlar',
                        hint: 'Sunulan olanaklar ve avantajlar...',
                        icon: Icons.card_giftcard_rounded,
                        initialValue: viewModel.benefits,
                        onChanged: (v) => viewModel.benefits = v,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ---- Son Başvuru Tarihi ----
                  _FormCard(
                    delay: 250,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.event_outlined,
                            size: 18,
                            color: Color(0xFF71717A),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Son Başvuru Tarihi',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3F3F46),
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: viewModel.hasDeadline,
                            activeThumbColor: const Color(0xFF4F46E5),
                            activeTrackColor: const Color(0xFF4F46E5).withAlpha(80),
                            onChanged: viewModel.toggleDeadline,
                          ),
                        ],
                      ),
                      if (viewModel.hasDeadline) ...[
                        const _FieldDivider(),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: viewModel.deadline ??
                                  DateTime.now().add(const Duration(days: 14)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const SizedBox(width: 28),
                                Text(
                                  viewModel.deadline != null
                                      ? '${viewModel.deadline!.day}.${viewModel.deadline!.month}.${viewModel.deadline!.year}'
                                      : 'Tarih seçin',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: viewModel.deadline != null
                                        ? const Color(0xFF1A1A2E)
                                        : const Color(0xFFA1A1AA),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: Color(0xFFA1A1AA),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _SaveButton(viewModel: viewModel),
      ),
    );
  }

  SliverAppBar _buildAppBar(
      BuildContext context, EditJobViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF4F46E5),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(56, 0, 20, 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İlanı Düzenle',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              job.title,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white60,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
            ),
          ),
          child: const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.edit_note_rounded, color: Colors.white24, size: 80),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------
// Active Toggle Card
// -----------------------------------------------
class _ActiveToggleCard extends StatelessWidget {
  final EditJobViewModel viewModel;
  const _ActiveToggleCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isActive = viewModel.isActive;
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF059669).withAlpha(15)
                : const Color(0xFFEF4444).withAlpha(12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF059669).withAlpha(50)
                  : const Color(0xFFEF4444).withAlpha(40),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF059669).withAlpha(20)
                      : const Color(0xFFEF4444).withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive
                      ? Icons.check_circle_rounded
                      : Icons.pause_circle_rounded,
                  color: isActive
                      ? const Color(0xFF059669)
                      : const Color(0xFFEF4444),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isActive ? 'İlan Aktif' : 'İlan Pasif',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive
                          ? 'Adaylar bu ilana başvurabilir'
                          : 'Yeni başvurular alınmıyor',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF71717A),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: isActive,
                activeThumbColor: const Color(0xFF059669),
                activeTrackColor: const Color(0xFF059669).withAlpha(80),
                inactiveThumbColor: const Color(0xFFEF4444),
                inactiveTrackColor: const Color(0xFFEF4444).withAlpha(40),
                onChanged: viewModel.setIsActive,
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 350.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

// -----------------------------------------------
// Section Header
// -----------------------------------------------
class _EditSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int delay;
  const _EditSectionHeader({
    required this.icon,
    required this.title,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        )
        .animate(delay: Duration(milliseconds: delay))
        .fade(duration: 300.ms);
  }
}

// -----------------------------------------------
// Form Card
// -----------------------------------------------
class _FormCard extends StatelessWidget {
  final List<Widget> children;
  final int delay;
  const _FormCard({required this.children, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fade(duration: 350.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

// -----------------------------------------------
// Input Field
// -----------------------------------------------
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF71717A)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF71717A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFA1A1AA),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Multiline Field
// -----------------------------------------------
class _MultilineField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _MultilineField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF71717A)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF71717A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            maxLines: 4,
            minLines: 2,
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFA1A1AA),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Dropdown Field
// -----------------------------------------------
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
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF71717A)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3F3F46),
              ),
            ),
          ),
          DropdownButton<T>(
            value: value,
            hint: Text(
              hint,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFA1A1AA),
              ),
            ),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.expand_more_rounded,
                size: 18, color: Color(0xFF71717A)),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF1A1A2E),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Segmented Picker
// -----------------------------------------------
class _SegmentedPicker extends StatelessWidget {
  final List<String> options;
  final String selected;
  final List<IconData> icons;
  final ValueChanged<String> onSelected;

  const _SegmentedPicker({
    required this.options,
    required this.selected,
    required this.icons,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(options[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFFF4F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[i],
                    size: 18,
                    color: isSelected ? Colors.white : const Color(0xFF71717A),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    options[i],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF71717A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// -----------------------------------------------
// Toggle Picker
// -----------------------------------------------
class _TogglePicker extends StatelessWidget {
  final List<String> options;
  final String selected;
  final List<Color> colors;
  final ValueChanged<String> onSelected;

  const _TogglePicker({
    required this.options,
    required this.selected,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        final color = colors[i];
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(options[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color : const Color(0xFFF4F4F8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? color : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  options[i],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? Colors.white : const Color(0xFF71717A),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// -----------------------------------------------
// Field Divider
// -----------------------------------------------
class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
    );
  }
}

// -----------------------------------------------
// Label Row
// -----------------------------------------------
class _LabelRow extends StatelessWidget {
  final String label;
  const _LabelRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF71717A),
      ),
    );
  }
}

// -----------------------------------------------
// Save Button
// -----------------------------------------------
class _SaveButton extends StatelessWidget {
  final EditJobViewModel viewModel;
  const _SaveButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: viewModel.isBusy ? null : viewModel.save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              disabledBackgroundColor: const Color(0xFF4F46E5).withAlpha(80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: viewModel.isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Değişiklikleri Kaydet',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
