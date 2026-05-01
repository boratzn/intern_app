import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import '../../../core/app_tops.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../my_jobs/my_jobs_view.dart';
import 'company_dashboard_viewmodel.dart';
import 'job_applicants_view.dart';

class CompanyDashboardView extends StatefulWidget {
  const CompanyDashboardView({super.key});

  @override
  State<CompanyDashboardView> createState() => _CompanyDashboardViewState();
}

class _CompanyDashboardViewState extends State<CompanyDashboardView>
    with RouteAware {
  CompanyDashboardViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      AppTops.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppTops.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => _viewModel?.refresh();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompanyDashboardViewModel>.reactive(
      viewModelBuilder: () => CompanyDashboardViewModel(),
      onViewModelReady: (viewModel) {
        _viewModel = viewModel;
        viewModel.init();
      },
      builder: (context, viewModel, child) {
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
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatsGrid(viewModel: viewModel),
                        const SizedBox(height: 20),
                        _ApplicantChartCard(viewModel: viewModel),
                        const SizedBox(height: 28),
                        _SectionHeader(
                          title: 'Açık İlanlar',
                          subtitle: '${viewModel.activeJobCount} aktif ilan',
                          onSeeAll: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MyJobsView(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    sliver: viewModel.activeJobs.isEmpty
                        ? const SliverToBoxAdapter(child: _EmptyJobs())
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _JobCard(
                                job: viewModel.activeJobs[index],
                                viewModel: viewModel,
                                index: index,
                              ),
                              childCount: viewModel.activeJobs.length,
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
      },
    );
  }

  SliverAppBar _buildAppBar(CompanyDashboardViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF4F46E5),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Text(
          'Şirket Paneli',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
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
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(15),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 60,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(10),
                ),
              ),
            ),
            Positioned(
              top: 52,
              left: 20,
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withAlpha(40),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hoş Geldiniz',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Şirket Yöneticisi',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// -----------------------------------------------
// Section Header
// -----------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              child: Text(
                'Tümünü Gör',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Stats Grid (2×2)
// -----------------------------------------------
class _StatsGrid extends StatelessWidget {
  final CompanyDashboardViewModel viewModel;
  const _StatsGrid({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        label: 'Toplam Başvuru',
        value: '${viewModel.totalApplicants}',
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF4F46E5),
        delay: 0,
      ),
      // _StatItem(
      //   label: 'Mülakat',
      //   value: '${viewModel.totalInterviews}',
      //   icon: Icons.record_voice_over_rounded,
      //   color: const Color(0xFF0EA5E9),
      //   delay: 80,
      // ),
      // _StatItem(
      //   label: 'Kabul Edildi',
      //   value: '${viewModel.totalOffers}',
      //   icon: Icons.verified_rounded,
      //   color: const Color(0xFF10B981),
      //   delay: 160,
      // ),
      _StatItem(
        label: 'Açık İlan',
        value: '${viewModel.activeJobCount}',
        icon: Icons.work_rounded,
        color: const Color(0xFFF59E0B),
        delay: 240,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.65,
        children: stats.map((s) => _StatCard(item: s)).toList(),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: item.color.withAlpha(20),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withAlpha(22),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.value,
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF71717A),
                          fontWeight: FontWeight.w500,
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
        .animate(delay: Duration(milliseconds: item.delay))
        .fade(duration: 350.ms)
        .slideY(begin: 0.15, end: 0);
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
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
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
              'Henüz aktif ilan yok',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yeni bir ilan oluşturarak başvuruları\ntakip etmeye başlayın.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF71717A),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------
// Job Card
// -----------------------------------------------
class _JobCard extends StatelessWidget {
  final JobListing job;
  final CompanyDashboardViewModel viewModel;
  final int index;

  const _JobCard({
    required this.job,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = job.applicants.length;

    return Semantics(
      label: '${job.title} ilanı, $totalCount başvuru',
      button: true,
      child:
          Container(
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
                  child: Stack(
                    children: [
                      // Left accent bar — full height via Positioned.fill
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 5,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            ),
                          ),
                        ),
                      ),
                      // Card content with left offset for the accent bar
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => JobApplicantsView(
                                job: job,
                                viewModel: viewModel,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(23, 18, 18, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.title,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: const Color(0xFF1A1A2E),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              _TagChip(
                                                label: job.department,
                                                color: const Color(0xFF4F46E5),
                                              ),
                                              _TagChip(
                                                label: job.type,
                                                color: const Color(0xFF0EA5E9),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    _ApplicantBadge(count: totalCount),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Location + date
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 14,
                                      color: Color(0xFFA1A1AA),
                                    ),
                                    const SizedBox(width: 4),
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
                                      size: 14,
                                      color: Color(0xFFA1A1AA),
                                    ),
                                    const SizedBox(width: 4),
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
                                const SizedBox(height: 14),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFF0F0F0),
                                ),
                                const SizedBox(height: 14),
                                // Pipeline chips
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      "Başvuruları Görüntüle",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF4F46E5),
                                        fontWeight: .bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF4F46E5,
                                        ).withAlpha(12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(delay: Duration(milliseconds: index * 80))
              .fade(duration: 400.ms)
              .slideY(begin: 0.08, end: 0),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TagChip({required this.label, required this.color});

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

class _ApplicantBadge extends StatelessWidget {
  final int count;
  const _ApplicantBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withAlpha(6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
            '$count',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F3F46),
            ),
          ),
          const SizedBox(width: 3),
          Text(
            'Başvuran',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF71717A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------
// Applicant Chart Card
// -----------------------------------------------

class _ApplicantChartCard extends StatefulWidget {
  final CompanyDashboardViewModel viewModel;
  const _ApplicantChartCard({required this.viewModel});

  @override
  State<_ApplicantChartCard> createState() => _ApplicantChartCardState();
}

class _ApplicantChartCardState extends State<_ApplicantChartCard> {
  ChartPeriod _period = ChartPeriod.weekly;

  String get _periodLabel {
    switch (_period) {
      case ChartPeriod.weekly:
        return 'Son 7 gün';
      case ChartPeriod.monthly:
        return 'Son 4 hafta';
      case ChartPeriod.yearly:
        return 'Son 12 ay';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.viewModel.getApplicantChartData(_period);
    final total = data.fold<int>(0, (s, p) => s + p.count);
    final maxY = data.map((p) => p.count).fold(0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Başvuru Analizi',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                _PeriodToggle(
                  selected: _period,
                  onChanged: (p) => setState(() => _period = p),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$total',
                  style: GoogleFonts.inter(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'başvuran',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF71717A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              _periodLabel,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFA1A1AA),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: EdgeInsets.zero,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: const Color(0xFF4F46E5),
                  textStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  format: 'point.x : point.y başvuru',
                ),
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  labelStyle: TextStyle(fontSize: 11, color: Color(0xFF71717A)),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                  minimum: 0,
                  maximum: maxY < 5 ? 5 : maxY * 1.3,
                ),
                series: <CartesianSeries<ApplicantChartPoint, String>>[
                  SplineAreaSeries<ApplicantChartPoint, String>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.label,
                    yValueMapper: (d, _) => d.count,
                    animationDuration: 800,
                    splineType: SplineType.natural,
                    gradient: const LinearGradient(
                      colors: [Color(0x554F46E5), Color(0x004F46E5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderColor: const Color(0xFF4F46E5),
                    borderWidth: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 7,
                      width: 7,
                      borderWidth: 2,
                      borderColor: Color(0xFF4F46E5),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 200.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}

class _PeriodToggle extends StatelessWidget {
  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onChanged;

  const _PeriodToggle({required this.selected, required this.onChanged});

  String _label(ChartPeriod p) {
    switch (p) {
      case ChartPeriod.weekly:
        return 'Hafta';
      case ChartPeriod.monthly:
        return 'Ay';
      case ChartPeriod.yearly:
        return 'Yıl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ChartPeriod.values.map((p) {
          final isSelected = p == selected;
          return GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                _label(p),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF71717A),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

