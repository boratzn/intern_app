import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/enums/application_status.dart';

// ── Design tokens ──────────────────────────────────────────────────────────
const _kPrimary = Color(0xFF4F46E5);
const _kPrimaryLight = Color(0xFF7C3AED);
const _kBg = Color(0xFFF5F6FA);
const _kSurface = Colors.white;
const _kTextPrimary = Color(0xFF111827);
const _kTextSecondary = Color(0xFF6B7280);
const _kBorder = Color(0xFFE5E7EB);
const _kSuccess = Color(0xFF059669);

/// Application tracker page — shows a visual timeline of the application flow.
class ApplicationTrackerView extends StatelessWidget {
  final Map<String, dynamic> applicationData;

  const ApplicationTrackerView({super.key, required this.applicationData});

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the ordered steps for the timeline based on [current].
  List<ApplicationStatus> _buildSteps(ApplicationStatus current) {
    const base = [
      ApplicationStatus.applied,
      ApplicationStatus.underReview,
      ApplicationStatus.assessment,
      ApplicationStatus.interview,
    ];
    final isNegativeTerminal =
        current == ApplicationStatus.rejected ||
        current == ApplicationStatus.withdrawn;
    if (isNegativeTerminal) return [...base, current];
    return [...base, ApplicationStatus.hired];
  }

  @override
  Widget build(BuildContext context) {
    final job = applicationData['job_listings'];
    final company = job?['company_profiles'];
    final statusString = applicationData['status']?.toString();
    final currentStatus = ApplicationStatus.fromString(statusString);
    final meetingUrl = applicationData['meeting_url']?.toString();
    final meetingDate = applicationData['meeting_date']?.toString();
    final appliedAt = applicationData['applied_at'] != null
        ? DateTime.tryParse(applicationData['applied_at'])
        : null;

    final steps = _buildSteps(currentStatus);
    final currentIndex = steps.indexOf(currentStatus);

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────────────
          _GradientHeader(
            job: job,
            company: company,
            appliedAt: appliedAt,
            currentStatus: currentStatus,
          ),

          // ── Scrollable content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meeting card — only for interview status
                  if (currentStatus == ApplicationStatus.interview &&
                      (meetingUrl != null || meetingDate != null)) ...[
                    _MeetingCard(
                      meetingDate: meetingDate,
                      meetingUrl: meetingUrl,
                    )
                        .animate(delay: 100.ms)
                        .fade()
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 16),
                  ],

                  // Status banner
                  _StatusBanner(status: currentStatus)
                      .animate(delay: 150.ms)
                      .fade()
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  // Timeline section title
                  Text(
                    'Başvuru Süreci',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kTextPrimary,
                    ),
                  ).animate(delay: 200.ms).fade(),

                  const SizedBox(height: 12),

                  // Timeline card
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    decoration: BoxDecoration(
                      color: _kSurface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(steps.length, (i) {
                        final status = steps[i];
                        final isPast = i < currentIndex;
                        final isCurrent = i == currentIndex;
                        final isLast = i == steps.length - 1;

                        return _TimelineStep(
                          status: status,
                          isPast: isPast,
                          isCurrent: isCurrent,
                          isLast: isLast,
                          delay: Duration(milliseconds: 220 + i * 60),
                        );
                      }),
                    ),
                  ).animate(delay: 200.ms).fade().slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Header ────────────────────────────────────────────────────────
class _GradientHeader extends StatelessWidget {
  final Map<String, dynamic>? job;
  final Map<String, dynamic>? company;
  final DateTime? appliedAt;
  final ApplicationStatus currentStatus;

  const _GradientHeader({
    required this.job,
    required this.company,
    required this.appliedAt,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kPrimary, _kPrimaryLight],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button + title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Başvuru Takibi',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Company + job info
          Row(
            children: [
              // Company logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: company?['logo_url'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          company!['logo_url'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.business_rounded,
                        color: _kPrimary,
                        size: 28,
                      ),
              ),

              const SizedBox(width: 14),

              // Job info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job?['title'] ?? 'İlan',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company?['company_name'] ?? 'Bilinmeyen Şirket',
                      style: GoogleFonts.inter(
                        color: Colors.white.withAlpha(200),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (appliedAt != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white.withAlpha(160),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Başvuru: ${DateFormat('dd.MM.yyyy').format(appliedAt!)}',
                            style: GoogleFonts.inter(
                              color: Colors.white.withAlpha(160),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Status Banner ──────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final ApplicationStatus status;
  const _StatusBanner({required this.status});

  String get _description {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Başvurunuz şirkete iletildi. İnceleme sürecini bekliyorsunuz.';
      case ApplicationStatus.underReview:
        return 'Başvurunuz işe alım ekibi tarafından inceleniyor.';
      case ApplicationStatus.assessment:
        return 'Değerlendirme sürecine alındınız. Sınav veya ön eleme adımı.';
      case ApplicationStatus.interview:
        return 'Mülakat aşamasına davet edildiniz. Tebrikler!';
      case ApplicationStatus.hired:
        return 'Kabul edildiniz! Şirket sizinle iletişime geçecek.';
      case ApplicationStatus.rejected:
        return 'Maalesef bu başvurunuz olumsuz sonuçlandı.';
      case ApplicationStatus.withdrawn:
        return 'Bu başvuruyu geri çektiniz.';
    }
  }

  Color get _bgColor => status.color.withAlpha(18);
  Color get _borderColor => status.color.withAlpha(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: status.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                status.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: status.color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _kTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Meeting Card ───────────────────────────────────────────────────────────
class _MeetingCard extends StatelessWidget {
  final String? meetingDate;
  final String? meetingUrl;

  const _MeetingCard({required this.meetingDate, required this.meetingUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.video_camera_front_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mülakat Daveti',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (meetingDate != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white.withAlpha(180),
                  size: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  meetingDate!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
          if (meetingUrl != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Launch meeting URL with url_launcher
                  debugPrint('Launching $meetingUrl');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _kPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.link_rounded, size: 18),
                label: Text(
                  'Toplantıya Katıl',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Timeline Step ──────────────────────────────────────────────────────────
class _TimelineStep extends StatelessWidget {
  final ApplicationStatus status;
  final bool isPast;
  final bool isCurrent;
  final bool isLast;
  final Duration delay;

  const _TimelineStep({
    required this.status,
    required this.isPast,
    required this.isCurrent,
    required this.isLast,
    required this.delay,
  });

  Color get _stepColor {
    if (isCurrent) return status.color;
    if (isPast) return _kSuccess;
    return _kBorder;
  }

  Color get _lineColor => isPast ? _kSuccess : _kBorder;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left: indicator + connector ──────────────────────────────────
        SizedBox(
          width: 40,
          child: Column(
            children: [
              // Circle
              _StepCircle(
                status: status,
                isPast: isPast,
                isCurrent: isCurrent,
                color: _stepColor,
              ),

              // Connector line
              if (!isLast)
                Container(
                  width: 2,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _lineColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // ── Right: step content ──────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 2,
              bottom: isLast ? 16 : 0,
            ),
            child: _StepContent(
              status: status,
              isPast: isPast,
              isCurrent: isCurrent,
              stepColor: _stepColor,
            ),
          ),
        ),
      ],
    ).animate(delay: delay).fade().slideX(begin: -0.05, end: 0);
  }
}

// ── Step Circle Indicator ──────────────────────────────────────────────────
class _StepCircle extends StatelessWidget {
  final ApplicationStatus status;
  final bool isPast;
  final bool isCurrent;
  final Color color;

  const _StepCircle({
    required this.status,
    required this.isPast,
    required this.isCurrent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isPast) {
      // Completed: filled green circle with check
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _kSuccess,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _kSuccess.withAlpha(60),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
      );
    }

    if (isCurrent) {
      // Active: colored ring + inner circle with emoji
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withAlpha(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(50),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(status.emoji, style: const TextStyle(fontSize: 13)),
        ),
      );
    }

    // Future: grey outlined circle with number
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: _kBorder, width: 1.5),
      ),
      child: Center(
        child: Text(
          status.emoji,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

// ── Step Content ───────────────────────────────────────────────────────────
class _StepContent extends StatelessWidget {
  final ApplicationStatus status;
  final bool isPast;
  final bool isCurrent;
  final Color stepColor;

  const _StepContent({
    required this.status,
    required this.isPast,
    required this.isCurrent,
    required this.stepColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      // Highlighted card for active step
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: stepColor.withAlpha(12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: stepColor.withAlpha(50)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                status.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: stepColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: stepColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Aktif',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Past or future step — plain row
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        status.label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isPast ? FontWeight.w600 : FontWeight.w400,
          color: isPast ? _kTextPrimary : _kTextSecondary,
        ),
      ),
    );
  }
}
