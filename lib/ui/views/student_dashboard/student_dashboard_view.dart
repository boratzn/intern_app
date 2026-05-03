import 'package:flutter/material.dart';
import 'package:intern_app/core/app_tops.dart';
import 'package:intern_app/core/models/notification_model.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'student_dashboard_viewmodel.dart';

// ── Design tokens ────────────────────────────────────────────────────
const _kPrimary = Color(0xFF1B365D);
const _kPrimaryMid = Color(0xFF1E4A8A);
const _kAccent = Color(0xFFF4A261);
const _kSuccess = Color(0xFF2A9D8F);
const _kDanger = Color(0xFFEF4444);
const _kBg = Color(0xFFF0F4F8);
const _kTextPrimary = Color(0xFF1A2B4A);
const _kTextSecondary = Color(0xFF718096);
const _kBorder = Color(0xFFE2E8F0);

class StudentDashboardView extends StackedView<StudentDashboardViewModel> {
  const StudentDashboardView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StudentDashboardViewModel viewModel,
    Widget? child,
  ) {
    final notifCount = viewModel.unreadNotificationsCount;

    return Scaffold(
      backgroundColor: _kBg,
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetchRecentJobs(),
        color: _kPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              // ── Fixed Header ──────────────────────────────────────────────
              _HeroSection(
                viewModel: viewModel,
                notifCount: notifCount,
                onNotificationTap: () =>
                    _showNotificationsSheet(context, viewModel),
              ),

              // ── Body ────────────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category filter chips — always visible
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _CategoryChipsBar(viewModel: viewModel),
                  ),

                  if (viewModel.isSearchActive)
                    _SearchResultsSection(viewModel: viewModel)
                  else
                    _RecentJobsSection(viewModel: viewModel),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _showNotificationsSheet(
    BuildContext context,
    StudentDashboardViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationsSheet(viewModel: viewModel),
    );
  }

  @override
  void onViewModelReady(StudentDashboardViewModel viewModel) =>
      viewModel.init();

  @override
  StudentDashboardViewModel viewModelBuilder(BuildContext context) =>
      StudentDashboardViewModel();
}

// ── Hero Section ──────────────────────────────────────────────────────
class _HeroSection extends StatefulWidget {
  final StudentDashboardViewModel viewModel;
  final int notifCount;
  final VoidCallback onNotificationTap;

  const _HeroSection({
    required this.viewModel,
    required this.notifCount,
    required this.onNotificationTap,
  });

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.viewModel.onSearchChanged('');
    _focusNode.unfocus();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterBottomSheet(viewModel: widget.viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final initial = viewModel.firstName.isNotEmpty
        ? viewModel.firstName[0].toUpperCase()
        : 'S';
    final hasText = _controller.text.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kPrimary, _kPrimaryMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Staj Bul',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  _NotificationBell(
                    count: widget.notifCount,
                    onTap: widget.onNotificationTap,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Greeting row
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _kAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _kAccent.withAlpha(100),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba, ${viewModel.firstName} 👋',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hayalindeki stajı bul',
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Search bar — active TextField
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(64)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          hintText: 'Pozisyon veya şirket ara...',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {});
                          viewModel.onSearchChanged(value);
                        },
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    if (hasText)
                      Semantics(
                        label: 'Aramayı temizle',
                        button: true,
                        child: GestureDetector(
                          onTap: _clearSearch,
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    else
                      Semantics(
                        label: 'Filtrele',
                        button: true,
                        child: GestureDetector(
                          onTap: () => _showFilterSheet(context),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: viewModel.hasActiveFilters
                                      ? Colors.white
                                      : _kAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: viewModel.hasActiveFilters
                                      ? _kPrimary
                                      : Colors.white,
                                  size: 16,
                                ),
                              ),
                              if (viewModel.activeFilterCount > 0)
                                Positioned(
                                  top: -4,
                                  right: 2,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: _kDanger,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${viewModel.activeFilterCount}',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Active filter chips — shown below search bar
              if (viewModel.hasActiveFilters) ...[
                const SizedBox(height: 10),
                _ActiveFilterChips(viewModel: viewModel),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Active Filter Chips ───────────────────────────────────────────────
class _ActiveFilterChips extends StatelessWidget {
  final StudentDashboardViewModel viewModel;
  const _ActiveFilterChips({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final chips = <_ActiveChip>[];

    for (final cat in viewModel.filterCategories) {
      chips.add(
        _ActiveChip(
          label: cat,
          onRemove: () {
            final updated = Set<String>.from(viewModel.filterCategories)
              ..remove(cat);
            viewModel.applyFilters(
              categories: updated,
              workTypes: viewModel.filterWorkTypes,
              compensations: viewModel.filterCompensations,
              dateRange: viewModel.filterDateRange,
              durations: viewModel.filterDurations,
            );
          },
        ),
      );
    }
    for (final wt in viewModel.filterWorkTypes) {
      chips.add(
        _ActiveChip(
          label: wt,
          onRemove: () {
            final updated = Set<String>.from(viewModel.filterWorkTypes)
              ..remove(wt);
            viewModel.applyFilters(
              categories: viewModel.filterCategories,
              workTypes: updated,
              compensations: viewModel.filterCompensations,
              dateRange: viewModel.filterDateRange,
              durations: viewModel.filterDurations,
            );
          },
        ),
      );
    }
    for (final comp in viewModel.filterCompensations) {
      chips.add(
        _ActiveChip(
          label: comp,
          onRemove: () {
            final updated = Set<String>.from(viewModel.filterCompensations)
              ..remove(comp);
            viewModel.applyFilters(
              categories: viewModel.filterCategories,
              workTypes: viewModel.filterWorkTypes,
              compensations: updated,
              dateRange: viewModel.filterDateRange,
              durations: viewModel.filterDurations,
            );
          },
        ),
      );
    }
    if (viewModel.filterDateRange != null) {
      chips.add(
        _ActiveChip(
          label: viewModel.filterDateRange!,
          onRemove: () => viewModel.applyFilters(
            categories: viewModel.filterCategories,
            workTypes: viewModel.filterWorkTypes,
            compensations: viewModel.filterCompensations,
            dateRange: null,
            durations: viewModel.filterDurations,
          ),
        ),
      );
    }
    for (final dur in viewModel.filterDurations) {
      chips.add(
        _ActiveChip(
          label: dur,
          onRemove: () {
            final updated = Set<String>.from(viewModel.filterDurations)
              ..remove(dur);
            viewModel.applyFilters(
              categories: viewModel.filterCategories,
              workTypes: viewModel.filterWorkTypes,
              compensations: viewModel.filterCompensations,
              dateRange: viewModel.filterDateRange,
              durations: updated,
            );
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map(
              (chip) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: chip,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.close_rounded, color: Colors.white70, size: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Bell ─────────────────────────────────────────────────
class _NotificationBell extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _NotificationBell({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 26,
          ),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: _kDanger,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Category Chips ────────────────────────────────────────────────────
class _CategoryChipsBar extends StatefulWidget {
  final StudentDashboardViewModel viewModel;
  const _CategoryChipsBar({required this.viewModel});

  @override
  State<_CategoryChipsBar> createState() => _CategoryChipsBarState();
}

class _CategoryChipsBarState extends State<_CategoryChipsBar> {
  int _selected = 0;

  /// Bilinen kategorilere özel ikon; bilinmeyenlere varsayılan ikon.
  static const _knownIcons = <String, IconData>{
    'Tümü': Icons.grid_view_rounded,
    'Teknoloji': Icons.computer_rounded,
    'Tasarım': Icons.design_services_rounded,
    'Pazarlama': Icons.trending_up_rounded,
    'Finans': Icons.account_balance_rounded,
    'Mühendislik': Icons.engineering_rounded,
  };

  IconData _iconFor(String name) =>
      _knownIcons[name] ?? Icons.work_outline_rounded;

  /// 'Tümü' + Supabase'den gelen kategoriler.
  List<String> get _labels {
    final cats = AppTops.categories.map((c) => c.categoryName).toList();
    return ['Tümü', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    final labels = _labels;

    // Kategoriler henüz yüklenmediyse (ağ hatası vb.) chip bar'ı gizle.
    if (labels.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final isSelected = _selected == index;
          final label = labels[index];
          return GestureDetector(
            onTap: () {
              setState(() => _selected = index);
              widget.viewModel.onCategoryChanged(label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? _kPrimary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? _kPrimary : _kBorder),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _kPrimary.withAlpha(64),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFor(label),
                    size: 13,
                    color: isSelected ? Colors.white : _kTextSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : _kTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Filter Bottom Sheet (Trendyol style) ─────────────────────────────
class _FilterBottomSheet extends StatefulWidget {
  final StudentDashboardViewModel viewModel;
  const _FilterBottomSheet({required this.viewModel});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  int _activeTab = 0;

  // Local filter copies — applied only on "Uygula"
  late Set<String> _categories;
  late Set<String> _workTypes;
  late Set<String> _compensations;
  late String? _dateRange;
  late Set<String> _durations;

  static const _tabs = [
    'Kategori',
    'Çalışma Şekli',
    'İlan Tarihi',
    'Ücret',
    'Süre',
  ];

  static const _staticOptions = <String, List<String>>{
    'Çalışma Şekli': ['Uzaktan', 'Hibrit', 'Ofiste'],
    'İlan Tarihi': ['Bugün', 'Son 3 Gün', 'Son 1 Hafta', 'Son 1 Ay'],
    'Ücret': ['Ücretli', 'Ücretsiz'],
    'Süre': ['1-3 Ay', '3-6 Ay', '6+ Ay'],
  };

  /// Aktif tab'a göre seçenek listesini döndürür.
  /// 'Kategori' için [AppTops.categories]'ten dinamik olarak okur.
  List<String> _optionsFor(String tab) {
    if (tab == 'Kategori') {
      return AppTops.categories.map((c) => c.categoryName).toList();
    }
    return _staticOptions[tab] ?? [];
  }

  @override
  void initState() {
    super.initState();
    final vm = widget.viewModel;
    _categories = Set.from(vm.filterCategories);
    _workTypes = Set.from(vm.filterWorkTypes);
    _compensations = Set.from(vm.filterCompensations);
    _dateRange = vm.filterDateRange;
    _durations = Set.from(vm.filterDurations);
  }

  int get _localFilterCount =>
      _categories.length +
      _workTypes.length +
      _compensations.length +
      (_dateRange != null ? 1 : 0) +
      _durations.length;

  Set<String> _setFor(String tab) {
    switch (tab) {
      case 'Kategori':
        return _categories;
      case 'Çalışma Şekli':
        return _workTypes;
      case 'Ücret':
        return _compensations;
      case 'Süre':
        return _durations;
      case 'İlan Tarihi': // Handled separately via _dateRange (single-select)
        return {};
      default:
        return {};
    }
  }

  bool _isSelected(String tab, String option) {
    if (tab == 'İlan Tarihi') return _dateRange == option;
    return _setFor(tab).contains(option);
  }

  void _toggle(String tab, String option) {
    setState(() {
      if (tab == 'İlan Tarihi') {
        _dateRange = _dateRange == option ? null : option;
      } else {
        final set = _setFor(tab);
        if (set.contains(option)) {
          set.remove(option);
        } else {
          set.add(option);
        }
      }
    });
    _applyToViewModel();
  }

  void _applyToViewModel() {
    widget.viewModel.applyFilters(
      categories: _categories,
      workTypes: _workTypes,
      compensations: _compensations,
      dateRange: _dateRange,
      durations: _durations,
    );
  }

  void _clearAll() {
    setState(() {
      _categories.clear();
      _workTypes.clear();
      _compensations.clear();
      _dateRange = null;
      _durations.clear();
    });
    widget.viewModel.clearFilters();
  }

  void _apply() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final tab = _tabs[_activeTab];
    final options = _optionsFor(tab);
    final resultCount = widget.viewModel.filteredJobs.length;

    return Container(
      height: screenH * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle ─────────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  'Filtreler',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _kTextPrimary,
                  ),
                ),
                const Spacer(),
                if (_localFilterCount > 0)
                  TextButton(
                    onPressed: _clearAll,
                    style: TextButton.styleFrom(
                      foregroundColor: _kDanger,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 40),
                    ),
                    child: Text(
                      'Temizle',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _kDanger,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: _kTextSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: _kBorder),

          // ── Body: Left tabs + Right options ───────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left — tab list
                Container(
                  width: 120,
                  color: _kBg,
                  child: ListView.builder(
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final isActive = _activeTab == index;
                      final tabName = _tabs[index];
                      final count = _countForTab(tabName);

                      return GestureDetector(
                        onTap: () => setState(() => _activeTab = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: isActive
                                    ? _kPrimary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tabName,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isActive
                                        ? _kPrimary
                                        : _kTextSecondary,
                                  ),
                                ),
                              ),
                              if (count > 0)
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: _kPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$count',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Vertical divider
                const VerticalDivider(width: 1, color: _kBorder),

                // Right — options
                Expanded(
                  child: options.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Kategoriler yüklenemedi',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: _kTextSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final selected = _isSelected(tab, option);

                            return Semantics(
                              label: option,
                              checked: selected,
                              child: InkWell(
                                onTap: () => _toggle(tab, option),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: selected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: selected
                                                ? _kPrimary
                                                : _kTextPrimary,
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? _kPrimary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: selected
                                                ? _kPrimary
                                                : _kBorder,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: selected
                                            ? const Icon(
                                                Icons.check_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: _kBorder),

          // ── Footer: Clear + Apply ──────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Row(
              children: [
                // Clear all button
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: _clearAll,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kTextPrimary,
                      side: const BorderSide(color: _kBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Temizle',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _kTextPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Apply button
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '$resultCount İlan Göster',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _countForTab(String tab) {
    switch (tab) {
      case 'Kategori':
        return _categories.length;
      case 'Çalışma Şekli':
        return _workTypes.length;
      case 'İlan Tarihi':
        return _dateRange != null ? 1 : 0;
      case 'Ücret':
        return _compensations.length;
      case 'Süre':
        return _durations.length;
      default:
        return 0;
    }
  }
}

// ── Recent Jobs Section ───────────────────────────────────────────────
class _RecentJobsSection extends StatelessWidget {
  final StudentDashboardViewModel viewModel;
  const _RecentJobsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isCategoryFiltered = viewModel.selectedCategory != 'Tümü';
    final jobs = isCategoryFiltered ? viewModel.filteredJobs : viewModel.recentJobs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SectionTitle(
            title: isCategoryFiltered
                ? viewModel.selectedCategory
                : 'Son Eklenenler',
            subtitle: isCategoryFiltered
                ? '${jobs.length} ilan bulundu'
                : 'En güncel staj fırsatları',
            icon: isCategoryFiltered
                ? Icons.filter_list_rounded
                : Icons.local_fire_department_rounded,
            iconColor: isCategoryFiltered ? _kPrimary : _kDanger,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: viewModel.isBusy && viewModel.recentJobs.isEmpty
              ? const _VerticalShimmer()
              : jobs.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final isApplied =
                        AppTops.appliedJobsIds.contains(job.id.toString());
                    return GestureDetector(
                      onTap: () => viewModel.navigateToJobDetail(job),
                      child: _JobListingCard(
                        job: job,
                        index: index,
                        isApplied: isApplied,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Search Results Section ────────────────────────────────────────────
class _SearchResultsSection extends StatelessWidget {
  final StudentDashboardViewModel viewModel;
  const _SearchResultsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.allJobsLoaded) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: _VerticalShimmer(),
      );
    }

    final results = viewModel.filteredJobs;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${results.length} ilan bulundu',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const _EmptySearchState()
          else
            ListView.separated(
              padding: EdgeInsets.only(top: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final job = results[index];
                final isApplied = AppTops.appliedJobsIds.contains(
                  job.id.toString(),
                );
                return GestureDetector(
                  onTap: () => viewModel.navigateToJobDetail(job),
                  child: _JobListingCard(
                    job: job,
                    index: index,
                    isApplied: isApplied,
                  ),
                ).animate().fade(duration: 250.ms, delay: (index * 40).ms);
              },
            ),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: _kBorder),
            const SizedBox(height: 14),
            Text(
              'Sonuç bulunamadı',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _kTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Farklı anahtar kelimeler deneyin',
              style: GoogleFonts.inter(fontSize: 13, color: _kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// // ── Application Stats ─────────────────────────────────────────────────
// class _ApplicationStats extends StatelessWidget {
//   final StudentDashboardViewModel viewModel;
//   const _ApplicationStats({required this.viewModel});

//   @override
//   Widget build(BuildContext context) {
//     final total = viewModel.appliedJobs.length;
//     final pending = viewModel.appliedJobs.where((a) {
//       final s = a['status']?.toString().toLowerCase() ?? '';
//       return s == 'applied' || s == 'pending';
//     }).length;
//     final updated = viewModel.activeApplications.length;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _kBorder),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(10),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _StatItem(value: '$total', label: 'Başvuru', color: _kPrimary),
//           _StatDivider(),
//           _StatItem(value: '$pending', label: 'Bekliyor', color: _kAccent),
//           _StatDivider(),
//           _StatItem(value: '$updated', label: 'Reddedildi', color: _kDanger),
//         ],
//       ),
//     ).animate().fade(duration: 400.ms).slideY(begin: 0.06, end: 0);
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String value;
//   final String label;
//   final Color color;
//   const _StatItem({
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: GoogleFonts.inter(
//               fontSize: 26,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               color: _kTextSecondary,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatDivider extends StatelessWidget {
//   const _StatDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Container(width: 1, height: 36, color: _kBorder);
//   }
// }

// ── Section Title ─────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _kTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

// ── AI Suggestion Card ────────────────────────────────────────────────
// class _AiSuggestionCard extends StatelessWidget {
//   final Map<String, dynamic> suggestion;
//   final int index;
//   const _AiSuggestionCard({required this.suggestion, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     const gradients = [
//       [Color(0xFF1B365D), Color(0xFF2D5A8E)],
//       [Color(0xFF4A90A4), Color(0xFF2A9D8F)],
//       [Color(0xFF1E4A8A), Color(0xFF4A90A4)],
//     ];
//     final grad = gradients[index % gradients.length];
//     final match = suggestion['match'] as int? ?? 0;
//     final company = suggestion['company'] as String? ?? '';
//     final title = suggestion['title'] as String? ?? '';
//     final companyInitial = company.isNotEmpty ? company[0].toUpperCase() : 'Ş';

//     return Container(
//           width: 220,
//           margin: const EdgeInsets.only(right: 14),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: grad,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: grad[0].withAlpha(100),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Top: company avatar + AI badge
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withAlpha(51),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Text(
//                         companyInitial,
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withAlpha(51),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.auto_awesome,
//                           color: Colors.white,
//                           size: 10,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'AI',
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               // Job info
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.inter(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     company,
//                     style: GoogleFonts.inter(
//                       color: Colors.white70,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),

//               // Bottom: match score + arrow
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 5,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withAlpha(51),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withAlpha(77)),
//                     ),
//                     child: Text(
//                       '%$match Uyum',
//                       style: GoogleFonts.inter(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withAlpha(51),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_rounded,
//                       color: Colors.white,
//                       size: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//         .animate()
//         .fade(duration: 500.ms, delay: (index * 100).ms)
//         .slideX(begin: 0.1, end: 0);
//   }
// }

// ── Job Listing Card ──────────────────────────────────────────────────
class _JobListingCard extends StatelessWidget {
  final dynamic job;
  final int index;
  final bool isApplied;
  const _JobListingCard({
    required this.job,
    required this.index,
    required this.isApplied,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = job.deadline?.difference(DateTime.now()).inDays;
    final companyName = job.company?.companyName ?? 'Bilinmeyen Şirket';
    final companyInitial = companyName.isNotEmpty
        ? companyName[0].toUpperCase()
        : 'Ş';

    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company logo / initials
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kBorder),
                ),
                child: job.company?.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          job.company!.logoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Text(
                          companyInitial,
                          style: GoogleFonts.inter(
                            color: _kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + applied badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: _kTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isApplied) ...[
                          const SizedBox(width: 6),
                          const _AppliedBadge(),
                        ],
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Company name
                    Text(
                      companyName,
                      style: GoogleFonts.inter(
                        color: _kPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Info chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (job.location != null &&
                            job.location.toString().isNotEmpty)
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: job.location,
                          ),
                        if (job.workType != null &&
                            job.workType.toString().isNotEmpty)
                          _InfoChip(
                            icon: Icons.work_outline_rounded,
                            label: job.workType,
                          ),
                        if (job.duration != null &&
                            job.duration.toString().isNotEmpty)
                          _InfoChip(
                            icon: Icons.access_time_rounded,
                            label: job.duration,
                          ),
                      ],
                    ),

                    // Deadline
                    if (daysLeft != null) ...[
                      const SizedBox(height: 10),
                      _DeadlineBadge(daysLeft: daysLeft),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFCBD5E0),
                size: 22,
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 400.ms, delay: ((index + 1) * 80).ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _AppliedBadge extends StatelessWidget {
  const _AppliedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _kSuccess.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kSuccess.withAlpha(77)),
      ),
      child: Text(
        '✓ Başvuruldu',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _kSuccess,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: _kTextSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  final int daysLeft;
  const _DeadlineBadge({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final isUrgent = daysLeft <= 7;
    final color = isUrgent ? _kDanger : _kTextSecondary;
    final label = daysLeft <= 0
        ? 'Son başvuru geçti'
        : daysLeft == 1
        ? 'Son 1 gün kaldı'
        : 'Son $daysLeft gün kaldı';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isUrgent ? Icons.timer_outlined : Icons.calendar_today_outlined,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Shimmer States ────────────────────────────────────────────────────
// class _HorizontalShimmer extends StatelessWidget {
//   const _HorizontalShimmer();

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       itemCount: 3,
//       itemBuilder: (_, __) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           width: 220,
//           margin: const EdgeInsets.only(right: 14),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _VerticalShimmer extends StatelessWidget {
  const _VerticalShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            height: 110,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

// // ── Empty States ──────────────────────────────────────────────────────
// class _EmptyHorizontal extends StatelessWidget {
//   const _EmptyHorizontal();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'AI önerileri yükleniyor...',
//         style: GoogleFonts.inter(color: _kTextSecondary),
//       ),
//     );
//   }
// }

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Center(
        child: Text(
          'Henüz ilan bulunmamaktadır.',
          style: GoogleFonts.inter(color: _kTextSecondary),
        ),
      ),
    );
  }
}

// ── Notifications Bottom Sheet ────────────────────────────────────────
// ── Notifications Sheet (reactive) ────────────────────────────────────
class _NotificationsSheet extends StatefulWidget {
  final StudentDashboardViewModel viewModel;
  const _NotificationsSheet({required this.viewModel});

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notifications = widget.viewModel.notifications;
    final unreadCount = widget.viewModel.unreadNotificationsCount;
    final totalCount = notifications.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // ── Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kPrimary, _kPrimaryMid],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bildirimler',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _kTextPrimary,
                      ),
                    ),
                    Text(
                      '$totalCount bildirim',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _kDanger,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$unreadCount yeni',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEF0F4)),

          // ── List
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_off_outlined,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz bildiriminiz yok',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: _kTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Başvurunuzdaki güncellemeler\nburada görünecek',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: _kTextSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: notifications.length,
                    itemBuilder: (ctx, index) {
                      final notification = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _NotificationCard(
                          notification: notification,
                          index: index,
                          onTap: () {
                            Navigator.pop(ctx);
                            widget.viewModel.navigateToNotification(
                              notification,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final int index;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isUnread ? Colors.white : const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(
                  color: isUnread ? _kPrimaryMid : Colors.transparent,
                  width: 3.5,
                ),
                top: BorderSide(color: const Color(0xFFEEF0F4), width: 1),
                right: BorderSide(color: const Color(0xFFEEF0F4), width: 1),
                bottom: BorderSide(color: const Color(0xFFEEF0F4), width: 1),
              ),
              boxShadow: isUnread
                  ? [
                      BoxShadow(
                        color: _kPrimary.withAlpha(18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Icon circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isUnread
                          ? _kPrimary.withAlpha(20)
                          : Colors.grey.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.campaign_rounded,
                      size: 22,
                      color: isUnread
                          ? _kPrimary
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ── Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: GoogleFonts.inter(
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 13,
                                  color: isUnread
                                      ? _kTextPrimary
                                      : _kTextSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUnread) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _kDanger,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'YENİ',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Message
                        Text(
                          notification.message,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isUnread
                                ? _kTextSecondary
                                : Colors.grey.shade400,
                            height: 1.45,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Bottom row: date + action
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd.MM.yyyy  HH:mm').format(
                                notification.createdAt.toLocal(),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const Spacer(),
                            if (notification.relatedId != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isUnread
                                      ? _kPrimary.withAlpha(15)
                                      : Colors.grey.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Detay',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isUnread
                                            ? _kPrimary
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: isUnread
                                          ? _kPrimary
                                          : Colors.grey.shade400,
                                    ),
                                  ],
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
          ),
        )
        .animate()
        .fade(duration: 300.ms, delay: (index * 50).ms)
        .slideY(begin: 0.05, end: 0);
  }
}
