import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_app/core/enums/application_status.dart';
import 'package:stacked/stacked.dart';

import 'company_dashboard_viewmodel.dart';
import 'applicant_detail_view.dart';

class JobApplicantsView extends StatelessWidget {
  final JobListing job;
  final CompanyDashboardViewModel _passedViewModel;

  const JobApplicantsView({
    super.key,
    required this.job,
    required CompanyDashboardViewModel viewModel,
  }) : _passedViewModel = viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompanyDashboardViewModel>.reactive(
      viewModelBuilder: () => _passedViewModel,
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                pinned: true,
                expandedHeight: 130,
                elevation: 0,
                backgroundColor: const Color(0xFF4F46E5),
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(56, 0, 16, 14),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.applicantCount} başvuru · ${job.department}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
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
                  ),
                ),
              ),

              // Status summary
              if (job.applicants.isNotEmpty)
                SliverToBoxAdapter(child: _StatusSummaryBar(job: job)),

              // Applicant list
              job.applicants.isEmpty
                  ? const SliverFillRemaining(child: _EmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final applicant = job.applicants[index];
                          return _ApplicantCard(
                            applicant: applicant,
                            jobId: job.id,
                            viewModel: viewModel,
                            index: index,
                          );
                        }, childCount: job.applicants.length),
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
// Status Summary Bar
// -----------------------------------------------
class _StatusSummaryBar extends StatelessWidget {
  final JobListing job;
  const _StatusSummaryBar({required this.job});

  @override
  Widget build(BuildContext context) {
    final counts = {
      ApplicationStatus.applied: job.applicants
          .where((a) => a.status == ApplicationStatus.applied)
          .length,
      ApplicationStatus.interview: job.applicants
          .where((a) => a.status == ApplicationStatus.interview)
          .length,
      ApplicationStatus.hired: job.applicants
          .where((a) => a.status == ApplicationStatus.hired)
          .length,
      ApplicationStatus.rejected: job.applicants
          .where((a) => a.status == ApplicationStatus.rejected)
          .length,
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            count: counts[ApplicationStatus.applied]!,
            label: 'Başvuru',
            color: const Color(0xFF6366F1),
          ),
          _SummaryDivider(),
          _SummaryItem(
            count: counts[ApplicationStatus.interview]!,
            label: 'Mülakat',
            color: const Color(0xFF0EA5E9),
          ),
          _SummaryDivider(),
          _SummaryItem(
            count: counts[ApplicationStatus.hired]!,
            label: 'Kabul',
            color: const Color(0xFF059669),
          ),
          _SummaryDivider(),
          _SummaryItem(
            count: counts[ApplicationStatus.rejected]!,
            label: 'Red',
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF71717A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: const Color(0xFFE5E7EB));
  }
}

// -----------------------------------------------
// Empty State
// -----------------------------------------------
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 36,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz başvuru yok',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu ilana yapılan başvurular burada görünecek.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFFA1A1AA),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Applicant Card
// -----------------------------------------------
class _ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final String jobId;
  final CompanyDashboardViewModel viewModel;
  final int index;

  const _ApplicantCard({
    required this.applicant,
    required this.jobId,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = applicant.status.color;
    final skills = applicant.skills
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .take(3)
        .toList();

    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ApplicantDetailView(
                    applicant: applicant,
                    jobId: jobId,
                    viewModel: viewModel,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: avatar + name + status chip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withAlpha(18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              applicant.name
                                  .split(' ')
                                  .map((w) => w.isNotEmpty ? w[0] : '')
                                  .take(2)
                                  .join(),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4F46E5),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + university
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applicant.name,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                applicant.university,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF71717A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status chip (static, no dropdown)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: statusColor.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                applicant.status.emoji,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                applicant.status.label,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    const SizedBox(height: 12),

                    // Info row: department + GPA
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.school_rounded,
                          label: applicant.department,
                          color: const Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 8),
                        if (applicant.gpa != '-')
                          _InfoChip(
                            icon: Icons.grade_rounded,
                            label: 'GPA ${applicant.gpa}',
                            color: const Color(0xFFF59E0B),
                          ),
                      ],
                    ),

                    // Skills (if any)
                    if (skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: skills
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0EA5E9).withAlpha(15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  s,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF0EA5E9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // Footer: "Detaylar" link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Detayları Görüntüle',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF4F46E5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 60))
        .fade(duration: 350.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
