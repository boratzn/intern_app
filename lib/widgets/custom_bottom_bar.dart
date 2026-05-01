import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom bottom navigation bar widget for the internship matching platform.
/// Implements bottom-heavy thumb zone strategy with role-based navigation.
///
/// This widget is parameterized and reusable across different implementations.
/// Navigation logic should be handled by the parent widget through callbacks.
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a navigation item is tapped
  final Function(int) onTap;

  /// Optional badge counts for each navigation item
  final List<int>? badgeCounts;

  /// Whether to show labels
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            // Subtle haptic feedback on tap
            HapticFeedback.lightImpact();
            onTap(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: theme.textTheme.bodySmall?.color,
          selectedFontSize: showLabels ? 12 : 0,
          unselectedFontSize: showLabels ? 12 : 0,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: [
            _buildNavigationItem(
              context: context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              index: 0,
            ),
            _buildNavigationItem(
              context: context,
              icon: Icons.work_outline,
              activeIcon: Icons.work,
              label: 'Jobs',
              index: 1,
            ),
            _buildNavigationItem(
              context: context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a navigation item with optional badge
  BottomNavigationBarItem _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final hasBadge =
        badgeCounts != null &&
        index < badgeCounts!.length &&
        badgeCounts![index] > 0;

    return BottomNavigationBarItem(
      icon: _buildIconWithBadge(
        context: context,
        icon: icon,
        hasBadge: hasBadge,
        badgeCount: hasBadge ? badgeCounts![index] : 0,
        isActive: false,
      ),
      activeIcon: _buildIconWithBadge(
        context: context,
        icon: activeIcon,
        hasBadge: hasBadge,
        badgeCount: hasBadge ? badgeCounts![index] : 0,
        isActive: true,
      ),
      label: label,
      tooltip: label,
    );
  }

  /// Builds an icon with optional badge overlay
  Widget _buildIconWithBadge({
    required BuildContext context,
    required IconData icon,
    required bool hasBadge,
    required int badgeCount,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget iconWidget = Icon(icon, size: 24);

    if (!hasBadge) {
      return iconWidget;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        iconWidget,
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFC73E1D), // Error color for notifications
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorScheme.surface, width: 1.5),
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Text(
              badgeCount > 99 ? '99+' : badgeCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// Extension to provide navigation routes for the bottom bar items
extension CustomBottomBarRoutes on CustomBottomBar {
  /// Get the route path for a given index
  static String getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/student-home-screen';
      case 1:
        return '/job-listings-screen';
      case 2:
        return '/student-profile-screen';
      default:
        return '/student-home-screen';
    }
  }

  /// Get the index for a given route path
  static int getIndexForRoute(String route) {
    switch (route) {
      case '/student-home-screen':
        return 0;
      case '/job-listings-screen':
        return 1;
      case '/student-profile-screen':
        return 2;
      default:
        return 0;
    }
  }
}
