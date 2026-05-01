import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../company_dashboard/company_dashboard_viewmodel.dart';
import '../company_dashboard/job_applicants_view.dart';
import '../edit_job/edit_job_view.dart';

class MyJobsView extends StackedView<CompanyDashboardViewModel> {
  const MyJobsView({super.key});

  @override
  CompanyDashboardViewModel viewModelBuilder(BuildContext context) =>
      CompanyDashboardViewModel();

  @override
  void onViewModelReady(CompanyDashboardViewModel viewModel) =>
      viewModel.init();

  @override
  Widget builder(
    BuildContext context,
    CompanyDashboardViewModel viewModel,
    Widget? child,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        top: false,
        child: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
              )
            : CustomScrollView(
                slivers: [
                  _buildAppBar(viewModel),
                  viewModel.jobs.isEmpty
                      ? const SliverFillRemaining(child: _EmptyJobs())
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _MyJobCard(
                                job: viewModel.jobs[index],
                                viewModel: viewModel,
                                index: index,
                              ),
                              childCount: viewModel.jobs.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  SliverAppBar _buildAppBar(CompanyDashboardViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF4F46E5),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İlanlarım',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${viewModel.totalJobs} ilan · ${viewModel.totalApplicants} toplam başvuru',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(12),
                ),
              ),
            ),
            const Positioned(
              top: 52,
              left: 20,
              child: Icon(
                Icons.work_outline_rounded,
                color: Colors.white24,
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------
// My Job Card
// -----------------------------------------------
class _MyJobCard extends StatelessWidget {
  final JobListing job;
  final CompanyDashboardViewModel viewModel;
  final int index;

  const _MyJobCard({
    required this.job,
    required this.viewModel,
    required this.index,
  });

  Future<void> _openApplicants(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JobApplicantsView(job: job, viewModel: viewModel),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditJobView(job: job)),
    );
    if (saved == true && context.mounted) {
      viewModel.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
          label: '${job.title} ilanı, ${job.applicantCount} başvuru',
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // --- Job info tappable area ---
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      onTap: () => _openApplicants(context),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title row + status badge
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    job.title,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _StatusBadge(isActive: job.isActive),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Department + type chips
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _Chip(
                                  label: job.department,
                                  color: const Color(0xFF4F46E5),
                                ),
                                _Chip(
                                  label: job.type,
                                  color: const Color(0xFF0EA5E9),
                                ),
                                if (job.duration.isNotEmpty)
                                  _Chip(
                                    label: job.duration,
                                    color: const Color(0xFFF59E0B),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Location + date row
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 13,
                                  color: Color(0xFFA1A1AA),
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    job.location,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFA1A1AA),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.schedule_rounded,
                                  size: 13,
                                  color: Color(0xFFA1A1AA),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  CompanyDashboardViewModel.daysSince(
                                    job.postedAt,
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFA1A1AA),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Applicant count
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFF1A1A2E).withAlpha(6),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.people_alt_rounded,
                                        size: 13,
                                        color: Color(0xFF71717A),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${job.applicantCount} Başvuran',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF3F3F46),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Başvuruları Gör',
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
                  // --- Divider ---
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  // --- Edit button ---
                  Semantics(
                    label: '${job.title} ilanını düzenle',
                    button: true,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openEdit(context),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 48),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit_rounded,
                                  size: 15,
                                  color: Color(0xFF71717A),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'İlanı Düzenle',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3F3F46),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 70))
        .fade(duration: 400.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

// -----------------------------------------------
// Status Badge
// -----------------------------------------------
class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? const Color(0xFF059669) : const Color(0xFFF59E0B);
    final label = isActive ? 'Aktif' : 'Pasif';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Chip
// -----------------------------------------------
class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// -----------------------------------------------
// Empty State
// -----------------------------------------------
class _EmptyJobs extends StatelessWidget {
  const _EmptyJobs();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              size: 40,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Henüz ilan yok',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"İlan Oluştur" sekmesinden ilk ilanınızı\nyayınlamaya başlayın.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF71717A),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
