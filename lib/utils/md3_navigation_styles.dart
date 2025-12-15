import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Material Design 3 Navigation 样式工具�?
/// 提供统一�?MD3 导航组件样式和变�?
class MD3NavigationStyles {
  /// 创建 MD3 AppBar
  /// 支持不同的变体和自定义选项
  static AppBar appBar({
    required BuildContext context,
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = false,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? toolbarHeight,
    double? leadingWidth,
    bool automaticallyImplyLeading = true,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    TextStyle? titleTextStyle,
    bool primary = true,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Clip? clipBehavior,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      surfaceTintColor: colorScheme.surfaceTint,
      shadowColor: colorScheme.shadow,
      shape: const RoundedRectangleBorder(),
      iconTheme: iconTheme ?? IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: actionsIconTheme ?? IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      titleTextStyle: titleTextStyle ?? theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics ?? false,
      titleSpacing: titleSpacing,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }

  /// 创建 MD3 SliverAppBar
  /// 支持可折叠的应用�?
  static SliverAppBar sliverAppBar({
    required BuildContext context,
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = false,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
    bool floating = false,
    bool pinned = false,
    bool snap = false,
    double? expandedHeight,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? toolbarHeight,
    double? leadingWidth,
    bool automaticallyImplyLeading = true,
    bool stretch = false,
    double stretchTriggerOffset = 100.0,
    double? collapsedHeight,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Clip? clipBehavior,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      surfaceTintColor: colorScheme.surfaceTint,
      shadowColor: colorScheme.shadow,
      shape: const RoundedRectangleBorder(),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
      stretch: stretch,
      stretchTriggerOffset: stretchTriggerOffset,
      collapsedHeight: collapsedHeight,
      excludeHeaderSemantics: excludeHeaderSemantics ?? false,
      titleSpacing: titleSpacing,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
    );
  }

  /// 创建 MD3 NavigationBar
  /// 底部导航�?
  static NavigationBar navigationBar({
    required BuildContext context,
    required List<NavigationDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? indicatorColor,
    ShapeBorder? indicatorShape,
    double? height,
    NavigationDestinationLabelBehavior? labelBehavior,
    WidgetStateProperty<Color?>? overlayColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationBar(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 3,
      shadowColor: shadowColor ?? colorScheme.shadow,
      surfaceTintColor: surfaceTintColor ?? colorScheme.surfaceTint,
      indicatorColor: indicatorColor ?? colorScheme.secondaryContainer,
      indicatorShape: indicatorShape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      height: height ?? 80,
      labelBehavior: labelBehavior ?? NavigationDestinationLabelBehavior.alwaysShow,
      overlayColor: overlayColor,
    );
  }

  /// 创建 MD3 NavigationRail
  /// 侧边导航栏，适用于平板和桌面
  static NavigationRail navigationRail({
    required BuildContext context,
    required List<NavigationRailDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    Color? backgroundColor,
    bool extended = false,
    Widget? leading,
    Widget? trailing,
    double? elevation,
    double? groupAlignment,
    NavigationRailLabelType? labelType,
    TextStyle? unselectedLabelTextStyle,
    TextStyle? selectedLabelTextStyle,
    IconThemeData? unselectedIconTheme,
    IconThemeData? selectedIconTheme,
    double? minWidth,
    double? minExtendedWidth,
    bool? useIndicator,
    Color? indicatorColor,
    ShapeBorder? indicatorShape,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationRail(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      extended: extended,
      leading: leading,
      trailing: trailing,
      elevation: elevation ?? 0,
      groupAlignment: groupAlignment ?? -1.0,
      labelType: labelType ?? (extended 
        ? NavigationRailLabelType.none 
        : NavigationRailLabelType.all),
      unselectedLabelTextStyle: unselectedLabelTextStyle ?? theme.textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      selectedLabelTextStyle: selectedLabelTextStyle ?? theme.textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      unselectedIconTheme: unselectedIconTheme ?? IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      selectedIconTheme: selectedIconTheme ?? IconThemeData(
        color: colorScheme.onSecondaryContainer,
        size: 24,
      ),
      minWidth: minWidth ?? 72,
      minExtendedWidth: minExtendedWidth ?? 256,
      useIndicator: useIndicator ?? true,
      indicatorColor: indicatorColor ?? colorScheme.secondaryContainer,
      indicatorShape: indicatorShape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  /// 创建 MD3 NavigationDrawer
  /// 抽屉导航
  static Drawer navigationDrawer({
    required BuildContext context,
    required List<Widget> children,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    double? width,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 1,
      shadowColor: shadowColor ?? colorScheme.shadow,
      surfaceTintColor: surfaceTintColor ?? colorScheme.surfaceTint,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      width: width,
      child: Column(
        children: children,
      ),
    );
  }

  /// 创建 MD3 NavigationDrawerDestination
  /// 抽屉导航�?
  static Widget navigationDrawerDestination({
    required BuildContext context,
    required Widget icon,
    required Widget label,
    Widget? selectedIcon,
    bool selected = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: selected ? (selectedIcon ?? icon) : icon,
        title: label,
        selected: selected,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        tileColor: selected ? colorScheme.secondaryContainer : null,
        selectedTileColor: colorScheme.secondaryContainer,
        iconColor: selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
        selectedColor: colorScheme.onSecondaryContainer,
        textColor: selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: false,
        visualDensity: VisualDensity.standard,
        minLeadingWidth: 24,
        minVerticalPadding: 8,
      ),
    );
  }

  /// 创建 MD3 TabBar
  /// 标签�?
  static TabBar tabBar({
    required BuildContext context,
    required List<Widget> tabs,
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    double indicatorWeight = 3.0,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    ValueChanged<int>? onTap,
    ScrollPhysics? physics,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TabBar(
      tabs: tabs,
      controller: controller,
      isScrollable: isScrollable,
      padding: padding,
      indicatorColor: indicatorColor ?? colorScheme.primary,
      indicatorWeight: indicatorWeight,
      indicatorPadding: indicatorPadding,
      indicator: indicator,
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
      dividerColor: dividerColor ?? colorScheme.surfaceContainerHighest,
      labelColor: labelColor ?? colorScheme.primary,
      labelStyle: labelStyle ?? theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelPadding: labelPadding,
      unselectedLabelColor: unselectedLabelColor ?? colorScheme.onSurfaceVariant,
      unselectedLabelStyle: unselectedLabelStyle ?? theme.textTheme.titleSmall,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      onTap: onTap,
      physics: physics,
    );
  }

  /// 创建标准�?MD3 导航目的�?
  static NavigationDestination createDestination({
    required IconData icon,
    required String label,
    IconData? selectedIcon,
    String? tooltip,
  }) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: selectedIcon != null ? Icon(selectedIcon) : null,
      label: label,
      tooltip: tooltip,
    );
  }

  /// 创建标准�?MD3 导航栏目的地
  static NavigationRailDestination createRailDestination({
    required IconData icon,
    required String label,
    IconData? selectedIcon,
    EdgeInsetsGeometry? padding,
  }) {
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: selectedIcon != null ? Icon(selectedIcon) : null,
      label: Text(label),
      padding: padding,
    );
  }
}

/// MD3 Navigation 变体枚举
enum MD3NavigationVariant {
  appBar,
  sliverAppBar,
  navigationBar,
  navigationRail,
  navigationDrawer,
  tabBar,
}

/// MD3 Navigation Builder
/// 提供更灵活的导航组件构建方式
class MD3NavigationBuilder {
  final BuildContext context;
  final MD3NavigationVariant variant;
  
  // 通用属�?
  Widget? _title;
  List<Widget>? _actions;
  Widget? _leading;
  bool _centerTitle = false;
  double? _elevation;
  Color? _backgroundColor;
  Color? _foregroundColor;
  
  // NavigationBar 特定属�?
  List<NavigationDestination>? _destinations;
  int? _selectedIndex;
  ValueChanged<int>? _onDestinationSelected;
  
  // TabBar 特定属�?
  List<Widget>? _tabs;
  TabController? _controller;
  bool _isScrollable = false;

  MD3NavigationBuilder({
    required this.context,
    required this.variant,
  });

  MD3NavigationBuilder title(Widget title) {
    _title = title;
    return this;
  }

  MD3NavigationBuilder actions(List<Widget> actions) {
    _actions = actions;
    return this;
  }

  MD3NavigationBuilder leading(Widget leading) {
    _leading = leading;
    return this;
  }

  MD3NavigationBuilder centerTitle(bool centerTitle) {
    _centerTitle = centerTitle;
    return this;
  }

  MD3NavigationBuilder elevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  MD3NavigationBuilder backgroundColor(Color backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  MD3NavigationBuilder foregroundColor(Color foregroundColor) {
    _foregroundColor = foregroundColor;
    return this;
  }

  MD3NavigationBuilder destinations(List<NavigationDestination> destinations) {
    _destinations = destinations;
    return this;
  }

  MD3NavigationBuilder selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    return this;
  }

  MD3NavigationBuilder onDestinationSelected(ValueChanged<int> onDestinationSelected) {
    _onDestinationSelected = onDestinationSelected;
    return this;
  }

  MD3NavigationBuilder tabs(List<Widget> tabs) {
    _tabs = tabs;
    return this;
  }

  MD3NavigationBuilder controller(TabController controller) {
    _controller = controller;
    return this;
  }

  MD3NavigationBuilder scrollable(bool isScrollable) {
    _isScrollable = isScrollable;
    return this;
  }

  Widget build() {
    switch (variant) {
      case MD3NavigationVariant.appBar:
        return MD3NavigationStyles.appBar(
          context: context,
          title: _title,
          actions: _actions,
          leading: _leading,
          centerTitle: _centerTitle,
          elevation: _elevation,
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
        );
      case MD3NavigationVariant.sliverAppBar:
        return MD3NavigationStyles.sliverAppBar(
          context: context,
          title: _title,
          actions: _actions,
          leading: _leading,
          centerTitle: _centerTitle,
          elevation: _elevation,
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
        );
      case MD3NavigationVariant.navigationBar:
        return MD3NavigationStyles.navigationBar(
          context: context,
          destinations: _destinations!,
          selectedIndex: _selectedIndex!,
          onDestinationSelected: _onDestinationSelected!,
          backgroundColor: _backgroundColor,
          elevation: _elevation,
        );
      case MD3NavigationVariant.tabBar:
        return MD3NavigationStyles.tabBar(
          context: context,
          tabs: _tabs!,
          controller: _controller,
          isScrollable: _isScrollable,
        );
      default:
        throw UnimplementedError('Navigation variant not implemented: $variant');
    }
  }
}
