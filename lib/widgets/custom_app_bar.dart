import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for the internship matching platform.
/// Implements clean professional header with minimal elevation strategy.
///
/// Supports multiple variants for different screen contexts while maintaining
/// consistent visual language across the application.
enum CustomAppBarVariant {
  /// Standard app bar with back button
  standard,

  /// Home screen app bar with logo/title and actions
  home,

  /// Search app bar with search field
  search,

  /// Detail screen app bar with transparent background
  transparent,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text to display
  final String? title;

  /// Leading widget (defaults to back button if canPop is true)
  final Widget? leading;

  /// Action widgets to display on the right
  final List<Widget>? actions;

  /// App bar variant
  final CustomAppBarVariant variant;

  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;

  /// Center the title
  final bool centerTitle;

  /// Custom background color
  final Color? backgroundColor;

  /// Elevation value
  final double? elevation;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// Search controller for search variant
  final TextEditingController? searchController;

  /// Search callback for search variant
  final ValueChanged<String>? onSearchChanged;

  /// Search hint text
  final String searchHint;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.variant = CustomAppBarVariant.standard,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.onBackPressed,
    this.searchController,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.bottom,
  });

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.home:
        return _buildHomeAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.transparent:
        return _buildTransparentAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.standard:
        return _buildStandardAppBar(context, theme, colorScheme);
    }
  }

  /// Builds standard app bar with back button
  Widget _buildStandardAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      leading:
          leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onBackPressed != null) {
                      onBackPressed!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      bottom: bottom,
    );
  }

  /// Builds home app bar with logo and actions
  Widget _buildHomeAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.work, color: colorScheme.onPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title ?? 'InternMatch',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      leading: leading,
      actions: actions,
      centerTitle: false,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      bottom: bottom,
    );
  }

  /// Builds search app bar with search field
  Widget _buildSearchAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: theme.textTheme.bodySmall?.color,
            ),
            suffixIcon: searchController?.text.isNotEmpty ?? false
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    onPressed: () {
                      searchController?.clear();
                      onSearchChanged?.call('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      ),
      leading:
          leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onBackPressed != null) {
                      onBackPressed!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      bottom: bottom,
    );
  }

  /// Builds transparent app bar for detail screens
  Widget _buildTransparentAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      leading:
          leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (onBackPressed != null) {
                        onBackPressed!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    tooltip: 'Back',
                  ),
                )
              : null),
      actions: actions?.map((action) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: action,
        );
      }).toList(),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      bottom: bottom,
    );
  }
}
