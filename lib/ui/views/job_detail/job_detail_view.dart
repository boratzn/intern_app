import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_app/core/app_tops.dart';
import 'package:intern_app/core/models/job_listing.dart';
import 'package:stacked/stacked.dart';

import 'job_detail_viewmodel.dart';

// ── Design tokens ─────────────────────────────────────────────────────
const _kPrimary = Color(0xFF1B365D);
const _kPrimaryMid = Color(0xFF1E4A8A);
const _kAccent = Color(0xFFF4A261);
const _kSuccess = Color(0xFF2A9D8F);
const _kBg = Color(0xFFF0F4F8);
const _kTextPrimary = Color(0xFF1A2B4A);
const _kTextSecondary = Color(0xFF718096);
const _kBorder = Color(0xFFE2E8F0);

class JobDetailView extends StackedView<JobDetailViewModel> {
  final JobListing job;
  const JobDetailView({super.key, required this.job});

  @override
  Widget builder(
    BuildContext context,
    JobDetailViewModel viewModel,
    Widget? child,
  ) {
    final categoryName = AppTops.categories
        .firstWhere((c) => c.id == job.categoryId)
        .categoryName;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero AppBar ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: _kPrimary,
                leading: _CircleBackButton(),
                actions: [
                  _BookmarkButton(viewModel: viewModel, context: context),
                  const SizedBox(width: 8),
                ],
                title: Text(
                  job.title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _HeroHeader(
                    title: job.title,
                    company: job.company?.companyName ?? 'Bilinmeyen Şirket',
                    match: 0,
                    location: job.location,
                    workType: job.workType,
                    categoryName: categoryName,
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    viewModel.isApplied ? 24 : 130,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Applied indicator
                      if (viewModel.isApplied) ...[
                        _AppliedBanner(),
                        const SizedBox(height: 16),
                      ],

                      // Requirements
                      if (job.requirements != null) ...[
                        _SectionCard(
                          icon: Icons.checklist_rounded,
                          iconColor: _kPrimary,
                          title: 'Aranan Yetkinlikler',
                          child: _RequirementChips(
                            requirements: job.requirements!,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Description
                      if (job.description.isNotEmpty) ...[
                        _SectionCard(
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF4A90A4),
                          title: 'İlan Hakkında',
                          child: _BodyText(text: job.description),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Benefits
                      if (job.benefits != null) ...[
                        _SectionCard(
                          icon: Icons.card_giftcard_rounded,
                          iconColor: _kAccent,
                          title: 'Sağlanan Yan Haklar',
                          child: _BenefitsList(benefits: job.benefits!),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Company description
                      if (job.company?.description != null) ...[
                        _SectionCard(
                          icon: Icons.domain_rounded,
                          iconColor: _kSuccess,
                          title: 'Şirket Hakkında',
                          child: _BodyText(text: job.company!.description!),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Contact phone
                      if (job.company?.contactPerson != null) ...[
                        _SectionCard(
                          icon: Icons.phone_rounded,
                          iconColor: const Color(0xFF8B5CF6),
                          title: 'İletişim',
                          child: _ContactRow(
                            phone:
                                job.company!.email ??
                                "Email adresi belirtilmemiş.",
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Sticky Apply Button ─────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _ApplyBar(viewModel: viewModel, context: context),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(JobDetailViewModel viewModel) => viewModel.init();

  @override
  JobDetailViewModel viewModelBuilder(BuildContext context) =>
      JobDetailViewModel(job);
}

// ── Circle Back Button ────────────────────────────────────────────────
class _CircleBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ── Bookmark Button ───────────────────────────────────────────────────
class _BookmarkButton extends StatelessWidget {
  final JobDetailViewModel viewModel;
  final BuildContext context;
  const _BookmarkButton({required this.viewModel, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        viewModel.toggleFavorite();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                viewModel.isFavorited
                    ? 'Favorilere eklendi.'
                    : 'Favorilerden çıkarıldı.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          shape: BoxShape.circle,
        ),
        child: Icon(
          viewModel.isFavorited
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          color: viewModel.isFavorited ? _kAccent : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String title;
  final String company;
  final int match;
  final String location;
  final String workType;
  final String categoryName;

  const _HeroHeader({
    required this.title,
    required this.company,
    required this.match,
    required this.location,
    required this.workType,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final initial = company.isNotEmpty ? company[0].toUpperCase() : 'Ş';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kPrimary, _kPrimaryMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: _kAccent.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Match badge (if > 0)
              if (match > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kSuccess.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _kSuccess.withAlpha(100)),
                  ),
                  child: Text(
                    '✦ %$match Profil Uyumu',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Job title
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Company
              Text(
                company,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 14),

              // Quick chips
              Wrap(
                spacing: 8,
                children: [
                  if (location.isNotEmpty)
                    _HeaderChip(
                      icon: Icons.location_on_outlined,
                      label: location,
                    ),
                  if (workType.isNotEmpty)
                    _HeaderChip(
                      icon: Icons.work_outline_rounded,
                      label: workType,
                    ),
                  if (categoryName.isNotEmpty)
                    _HeaderChip(
                      icon: Icons.category_outlined,
                      label: categoryName,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Applied Banner ────────────────────────────────────────────────────
class _AppliedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kSuccess.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kSuccess.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _kSuccess, size: 20),
          const SizedBox(width: 10),
          Text(
            'Bu ilana başvurdunuz',
            style: GoogleFonts.inter(
              color: _kSuccess,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }
}

// ── Quick Info Grid ───────────────────────────────────────────────────
class _QuickInfoGrid extends StatelessWidget {
  final String location;
  final String workType;
  final String duration;
  final String compensationType;

  const _QuickInfoGrid({
    required this.location,
    required this.workType,
    required this.duration,
    required this.compensationType,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_InfoGridItem>[
      if (location.isNotEmpty)
        _InfoGridItem(
          icon: Icons.location_on_outlined,
          label: 'Konum',
          value: location,
          color: _kPrimary,
        ),
      if (workType.isNotEmpty)
        _InfoGridItem(
          icon: Icons.work_outline_rounded,
          label: 'Çalışma Şekli',
          value: workType,
          color: const Color(0xFF4A90A4),
        ),
      if (duration.isNotEmpty)
        _InfoGridItem(
          icon: Icons.access_time_rounded,
          label: 'Süre',
          value: duration,
          color: _kAccent,
        ),
      if (compensationType.isNotEmpty)
        _InfoGridItem(
          icon: Icons.payments_outlined,
          label: 'Ücret',
          value: compensationType,
          color: _kSuccess,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: item.color.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, size: 16, color: item.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.label,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: _kTextSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              item.value,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _kTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        )
        .animate()
        .fade(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _InfoGridItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoGridItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

// ── Section Card ──────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _kTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _kBorder),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

// ── Body Text ─────────────────────────────────────────────────────────
class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        height: 1.75,
        color: const Color(0xFF4A5568),
      ),
    );
  }
}

// ── Requirement Chips ─────────────────────────────────────────────────
class _RequirementChips extends StatelessWidget {
  final String requirements;
  const _RequirementChips({required this.requirements});

  static const _chipColors = [
    Color(0xFF1B365D),
    Color(0xFF4A90A4),
    Color(0xFF2A9D8F),
    Color(0xFF8B5CF6),
    Color(0xFFF4A261),
    Color(0xFFEF4444),
  ];

  @override
  Widget build(BuildContext context) {
    final items = requirements
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(items.length, (index) {
        final color = _chipColors[index % _chipColors.length];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withAlpha(16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Text(
            items[index],
            style: GoogleFonts.inter(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        );
      }),
    );
  }
}

// ── Benefits List ─────────────────────────────────────────────────────
class _BenefitsList extends StatelessWidget {
  final String benefits;
  const _BenefitsList({required this.benefits});

  @override
  Widget build(BuildContext context) {
    final items = benefits
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // If no separators found, show as plain text
    if (items.length <= 1) {
      return _BodyText(text: benefits);
    }

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _kAccent.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: _kAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Contact Row ───────────────────────────────────────────────────────
class _ContactRow extends StatelessWidget {
  final String phone;
  const _ContactRow({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withAlpha(12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: Color(0xFF8B5CF6),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telefon',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: _kTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                phone,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _kTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Apply Bar ─────────────────────────────────────────────────────────
class _ApplyBar extends StatelessWidget {
  final JobDetailViewModel viewModel;
  final BuildContext context;
  const _ApplyBar({required this.viewModel, required this.context});

  @override
  Widget build(BuildContext context) {
    final isApplied = viewModel.isApplied;

    if (isApplied) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: isApplied
              ? null
              : () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final success = await viewModel.applyToJob();
                  if (success) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tebrikler! Başvurunuz alındı.',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: _kSuccess,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isApplied ? _kSuccess : _kPrimary,
            disabledBackgroundColor: _kSuccess,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isApplied ? Icons.check_circle_rounded : Icons.send_rounded,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                isApplied ? 'Başvuruldu' : 'Hemen Başvur',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
