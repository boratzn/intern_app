import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_app/core/enums/application_status.dart';
import 'package:stacked/stacked.dart';

import 'company_dashboard_viewmodel.dart';

class ApplicantDetailView extends StatelessWidget {
  final Applicant applicant;
  final String jobId;
  final CompanyDashboardViewModel _passedViewModel;

  const ApplicantDetailView({
    super.key,
    required this.applicant,
    required this.jobId,
    required CompanyDashboardViewModel viewModel,
  }) : _passedViewModel = viewModel;

  Color _matchColor(int score) {
    if (score >= 85) return const Color(0xFF10B981);
    if (score >= 70) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompanyDashboardViewModel>.reactive(
      viewModelBuilder: () => _passedViewModel,
      disposeViewModel: false, // Using parent's viewmodel
      builder: (context, viewModel, child) {
        final matchColor = _matchColor(applicant.matchScore);

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F8),
          body: CustomScrollView(
            slivers: [
              // --- Hero Header ---
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: const Color(0xFF4F46E5),
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 44),
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.white.withAlpha(40),
                            child: Text(
                              applicant.name
                                  .split(' ')
                                  .map((w) => w[0])
                                  .take(2)
                                  .join(),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            applicant.name,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            applicant.university,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Match Score + Status
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.analytics_outlined,
                            label: 'Eşleşme Skoru',
                            value: '%${applicant.matchScore}',
                            valueColor: matchColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.flag_outlined,
                            label: 'Durum',
                            value:
                                '${applicant.status.emoji} ${applicant.status.label}',
                            valueColor: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // Academic Info
                    _SectionCard(
                          title: 'Akademik Bilgiler',
                          icon: Icons.school_outlined,
                          children: [
                            _DetailRow(
                              label: 'Üniversite',
                              value: applicant.university,
                            ),
                            _DetailRow(
                              label: 'Bölüm',
                              value: applicant.department,
                            ),
                            _DetailRow(label: 'GPA', value: applicant.gpa),
                          ],
                        )
                        .animate(delay: 100.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // Skills
                    _SectionCard(
                          title: 'Yetenekler',
                          icon: Icons.code_outlined,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: applicant.skills
                                  .split(',')
                                  .map((s) => _SkillChip(label: s.trim()))
                                  .toList(),
                            ),
                          ],
                        )
                        .animate(delay: 200.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // About
                    _SectionCard(
                          title: 'Hakkında / Ön Yazı',
                          icon: Icons.person_outline,
                          children: [
                            Text(
                              applicant.about,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF52525B),
                                height: 1.6,
                              ),
                            ),
                          ],
                        )
                        .animate(delay: 300.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // CV Placeholder
                    _SectionCard(
                          title: 'CV / Özgeçmiş',
                          icon: Icons.description_outlined,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE4E4E7),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withAlpha(20),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Color(0xFFEF4444),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${applicant.name.split(' ').first}_CV.pdf',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                        Text(
                                          'PDF Dokümanı',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFFA1A1AA),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      color: Color(0xFF4F46E5),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'CV görüntüleyici yakında eklenecek',
                                            style: GoogleFonts.inter(),
                                          ),
                                          backgroundColor: const Color(
                                            0xFF4F46E5,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        .animate(delay: 400.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // Status Changer
                    _StatusChanger(
                          applicant: applicant,
                          jobId: jobId,
                          viewModel: viewModel,
                        )
                        .animate(delay: 500.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------------------------
// Sub Widgets
// -----------------------------------------------

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFFA1A1AA)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFFA1A1AA),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFA1A1AA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4F46E5).withAlpha(40)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4F46E5),
        ),
      ),
    );
  }
}

class _StatusChanger extends StatefulWidget {
  final Applicant applicant;
  final String jobId;
  final CompanyDashboardViewModel viewModel;

  const _StatusChanger({
    required this.applicant,
    required this.jobId,
    required this.viewModel,
  });

  @override
  State<_StatusChanger> createState() => _StatusChangerState();
}

class _StatusChangerState extends State<_StatusChanger> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDateTime; // Stores actual DateTime for ISO conversion

  @override
  void dispose() {
    _urlController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showMeetingDialog(ApplicationStatus status) {
    // Pre-fill if already set
    _urlController.text = widget.applicant.meetingUrl ?? '';
    // Display the stored display date, or the raw meetingDate as fallback
    if (widget.applicant.meetingDate != null) {
      _dateController.text = widget.applicant.meetingDate!;
    } else {
      _dateController.text = '';
    }
    _selectedDateTime = null; // Reset picker selection

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Mülakat Bilgileri',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Aday için mülakat tarihini ve toplantı linkini giriniz.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Tarih ve Saat',
                      hintText: 'Örn: 15.04.2025 14:00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.edit_calendar_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Color(0xFF4F46E5),
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: dialogContext,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF4F46E5),
                                ),
                                dialogTheme: const DialogThemeData(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (date != null && dialogContext.mounted) {
                            final time = await showTimePicker(
                              context: dialogContext,
                              initialTime: TimeOfDay.now(),
                              builder: (ctx, child) => Theme(
                                data: Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF4F46E5),
                                  ),
                                  dialogTheme: const DialogThemeData(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (time != null) {
                              final pickedDt = DateTime(
                                date.year, date.month, date.day,
                                time.hour, time.minute,
                              );
                              final d = date.day.toString().padLeft(2, '0');
                              final mo = date.month.toString().padLeft(2, '0');
                              final y = date.year.toString();
                              final h = time.hour.toString().padLeft(2, '0');
                              final min = time.minute.toString().padLeft(2, '0');
                              final displayFormatted = '$d.$mo.$y $h:$min';
                              setDialogState(() {
                                _selectedDateTime = pickedDt;
                                _dateController.text = displayFormatted;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'Toplantı Linki (Zoom, Meet vs.)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'İptal',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    // Use ISO format for Supabase if picker was used,
                    // otherwise try to pass the raw text as-is (manual entry)
                    String? meetingDateToSave;
                    if (_selectedDateTime != null) {
                      // ISO 8601 format that Supabase/PostgreSQL accepts
                      meetingDateToSave = _selectedDateTime!.toIso8601String();
                    } else if (_dateController.text.isNotEmpty) {
                      // User typed manually, try to parse dd.MM.yyyy HH:mm
                      try {
                        final parts = _dateController.text.split(' ');
                        final dateParts = parts[0].split('.');
                        final timeParts = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
                        final parsedDt = DateTime(
                          int.parse(dateParts[2]),
                          int.parse(dateParts[1]),
                          int.parse(dateParts[0]),
                          int.parse(timeParts[0]),
                          int.parse(timeParts[1]),
                        );
                        meetingDateToSave = parsedDt.toIso8601String();
                      } catch (_) {
                        meetingDateToSave = null;
                      }
                    }
                    _update(
                      status,
                      meetingUrl: _urlController.text.isNotEmpty
                          ? _urlController.text
                          : null,
                      meetingDate: meetingDateToSave,
                    );
                  },
                  child: Text(
                    'Kaydet',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _update(
    ApplicationStatus status, {
    String? meetingUrl,
    String? meetingDate,
  }) {
    widget.viewModel.updateStatus(
      widget.jobId,
      widget.applicant.id,
      status,
      meetingUrl: meetingUrl?.isNotEmpty == true ? meetingUrl : null,
      meetingDate: meetingDate?.isNotEmpty == true ? meetingDate : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Durum "${status.label}" olarak güncellendi',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: status.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.swap_horiz_outlined,
                size: 18,
                color: Color(0xFF4F46E5),
              ),
              const SizedBox(width: 8),
              Text(
                'Aday Aşama İlerlemesi (Stepper)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),
          Stepper(
            physics: const ClampingScrollPhysics(),
            currentStep: ApplicationStatus.values.indexOf(
              widget.applicant.status,
            ),
            margin: const EdgeInsets.all(0),
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            onStepTapped: null,
            steps: ApplicationStatus.values.map((status) {
              final isCurrent = widget.applicant.status == status;
              final isPast =
                  ApplicationStatus.values.indexOf(widget.applicant.status) >=
                  ApplicationStatus.values.indexOf(status);
              final statusIdx = ApplicationStatus.values.indexOf(status);
              final hiredIdx = ApplicationStatus.values.indexOf(
                ApplicationStatus.hired,
              );
              final hasNextStep = statusIdx < hiredIdx;
              final nextStatus = hasNextStep
                  ? ApplicationStatus.values[statusIdx + 1]
                  : null;

              return Step(
                state: isCurrent
                    ? StepState.editing
                    : (isPast ? StepState.complete : StepState.indexed),
                isActive: isPast,
                title: Row(
                  children: [
                    Text(status.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      status.label,
                      style: GoogleFonts.inter(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isCurrent
                            ? status.color
                            : const Color(0xFF52525B),
                      ),
                    ),
                  ],
                ),
                content: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 16, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aday şu an bu aşamada.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF52525B),
                        ),
                      ),
                      if (status == ApplicationStatus.interview) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showMeetingDialog(status),
                          icon: const Icon(Icons.edit_calendar, size: 18),
                          label: const Text('Tarih ve Link Düzenle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: status.color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                      if (hasNextStep && nextStatus != null) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (nextStatus ==
                                  ApplicationStatus.interview) {
                                _showMeetingDialog(nextStatus);
                              } else {
                                _update(nextStatus);
                              }
                            },
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: Text(
                              '${nextStatus.emoji}  ${nextStatus.label} Aşamasına Geç',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
