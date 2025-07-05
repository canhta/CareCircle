import 'package:flutter/material.dart';
import 'performance_optimized_widget.dart';

/// Utility class for optimizing existing widgets with performance enhancements
class WidgetOptimizer {
  /// Optimizes a ListView by adding performance boundaries and keys
  static Widget optimizeListView({
    required List<Widget> children,
    EdgeInsets? padding,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    bool addRepaintBoundaries = true,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('listview_item_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return ListView(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: optimizedChildren,
    );
  }

  /// Optimizes a Column by adding keys and performance boundaries
  static Widget optimizeColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    bool addRepaintBoundaries = false,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('column_item_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: optimizedChildren,
    );
  }

  /// Optimizes a Row by adding keys and performance boundaries
  static Widget optimizeRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    bool addRepaintBoundaries = false,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('row_item_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: optimizedChildren,
    );
  }

  /// Wraps a widget with performance optimizations
  static Widget wrapWithOptimizations({
    required Widget child,
    bool useRepaintBoundary = true,
    bool useKeepAlive = false,
    String? debugLabel,
    Key? key,
  }) {
    return PerformanceOptimizedWidget(
      key: key,
      useRepaintBoundary: useRepaintBoundary,
      useKeepAlive: useKeepAlive,
      debugLabel: debugLabel,
      child: child,
    );
  }

  /// Creates an optimized card widget
  static Widget optimizedCard({
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
    Color? color,
    ShapeBorder? shape,
    bool useRepaintBoundary = true,
    Key? key,
  }) {
    Widget cardWidget = Card(
      key: key,
      margin: margin,
      elevation: elevation,
      color: color,
      shape: shape,
      child: padding != null
          ? Padding(
              padding: padding,
              child: child,
            )
          : child,
    );

    if (useRepaintBoundary) {
      cardWidget = RepaintBoundary(child: cardWidget);
    }

    return cardWidget;
  }

  /// Creates an optimized list tile
  static Widget optimizedListTile({
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool useRepaintBoundary = true,
    Key? key,
  }) {
    Widget listTile = ListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );

    if (useRepaintBoundary) {
      listTile = RepaintBoundary(child: listTile);
    }

    return listTile;
  }

  /// Creates an optimized grid view
  static Widget optimizedGridView({
    required List<Widget> children,
    required int crossAxisCount,
    double crossAxisSpacing = 0.0,
    double mainAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    bool addRepaintBoundaries = true,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('grid_item_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: optimizedChildren,
    );
  }

  /// Creates an optimized tab bar view
  static Widget optimizedTabBarView({
    required List<Widget> children,
    TabController? controller,
    ScrollPhysics? physics,
    bool addRepaintBoundaries = true,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('tab_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return TabBarView(
      controller: controller,
      physics: physics,
      children: optimizedChildren,
    );
  }

  /// Creates an optimized sliver list
  static Widget optimizedSliverList({
    required List<Widget> children,
    bool addRepaintBoundaries = true,
  }) {
    final optimizedChildren = addRepaintBoundaries
        ? children.asMap().entries.map((entry) {
            return RepaintBoundary(
              key: ValueKey('sliver_item_${entry.key}'),
              child: entry.value,
            );
          }).toList()
        : children;

    return SliverList(
      delegate: SliverChildListDelegate(optimizedChildren),
    );
  }

  /// Optimizes a widget tree by adding const constructors where possible
  static Widget constOptimize(Widget widget) {
    // This is a placeholder for a more sophisticated const optimization
    // In practice, this would require compile-time analysis
    return widget;
  }

  /// Creates an optimized animated widget wrapper
  static Widget optimizedAnimatedWidget({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool useRepaintBoundary = true,
  }) {
    Widget animatedWidget = AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );

    if (useRepaintBoundary) {
      animatedWidget = RepaintBoundary(child: animatedWidget);
    }

    return animatedWidget;
  }

  /// Creates an optimized future builder
  static Widget optimizedFutureBuilder<T>({
    required Future<T> future,
    required Widget Function(BuildContext context, T data) builder,
    Widget? loadingWidget,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    bool useRepaintBoundary = true,
  }) {
    Widget futureBuilder = FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data != null) {
          return builder(context, snapshot.data as T);
        }

        return const SizedBox.shrink();
      },
    );

    if (useRepaintBoundary) {
      futureBuilder = RepaintBoundary(child: futureBuilder);
    }

    return futureBuilder;
  }

  /// Creates an optimized stream builder
  static Widget optimizedStreamBuilder<T>({
    required Stream<T> stream,
    required Widget Function(BuildContext context, T data) builder,
    Widget? loadingWidget,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    bool useRepaintBoundary = true,
  }) {
    Widget streamBuilder = StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data != null) {
          return builder(context, snapshot.data as T);
        }

        return const SizedBox.shrink();
      },
    );

    if (useRepaintBoundary) {
      streamBuilder = RepaintBoundary(child: streamBuilder);
    }

    return streamBuilder;
  }

  /// Creates an optimized ListView.builder for dynamic lists
  static Widget optimizedListViewBuilder({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    EdgeInsets? padding,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    bool addRepaintBoundaries = true,
    bool addItemKeys = true,
  }) {
    return ListView.builder(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Widget item = itemBuilder(context, index);

        // Add key for efficient updates
        if (addItemKeys) {
          item = KeyedSubtree(
            key: ValueKey('listview_builder_item_$index'),
            child: item,
          );
        }

        // Add RepaintBoundary for performance
        if (addRepaintBoundaries) {
          item = RepaintBoundary(child: item);
        }

        return item;
      },
    );
  }

  /// Creates an optimized ListView.separated for dynamic lists with separators
  static Widget optimizedListViewSeparated({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    required Widget Function(BuildContext context, int index) separatorBuilder,
    EdgeInsets? padding,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    bool addRepaintBoundaries = true,
    bool addItemKeys = true,
  }) {
    return ListView.separated(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Widget item = itemBuilder(context, index);

        // Add key for efficient updates
        if (addItemKeys) {
          item = KeyedSubtree(
            key: ValueKey('listview_separated_item_$index'),
            child: item,
          );
        }

        // Add RepaintBoundary for performance
        if (addRepaintBoundaries) {
          item = RepaintBoundary(child: item);
        }

        return item;
      },
      separatorBuilder: separatorBuilder,
    );
  }

  /// Creates an optimized GridView.builder for dynamic grids
  static Widget optimizedGridViewBuilder({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    required SliverGridDelegate gridDelegate,
    EdgeInsets? padding,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    bool addRepaintBoundaries = true,
    bool addItemKeys = true,
  }) {
    return GridView.builder(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Widget item = itemBuilder(context, index);

        // Add key for efficient updates
        if (addItemKeys) {
          item = KeyedSubtree(
            key: ValueKey('gridview_builder_item_$index'),
            child: item,
          );
        }

        // Add RepaintBoundary for performance
        if (addRepaintBoundaries) {
          item = RepaintBoundary(child: item);
        }

        return item;
      },
    );
  }

  /// Creates an optimized RefreshIndicator
  static Widget optimizedRefreshIndicator({
    required Widget child,
    required Future<void> Function() onRefresh,
    Color? color,
    Color? backgroundColor,
    double displacement = 40.0,
    bool useRepaintBoundary = true,
  }) {
    Widget refreshIndicator = RefreshIndicator(
      onRefresh: onRefresh,
      color: color,
      backgroundColor: backgroundColor,
      displacement: displacement,
      child: child,
    );

    if (useRepaintBoundary) {
      refreshIndicator = RepaintBoundary(child: refreshIndicator);
    }

    return refreshIndicator;
  }

  /// Creates an optimized SingleChildScrollView
  static Widget optimizedSingleChildScrollView({
    required Widget child,
    Axis scrollDirection = Axis.vertical,
    EdgeInsets? padding,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool useRepaintBoundary = true,
  }) {
    Widget scrollView = SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      controller: controller,
      physics: physics,
      child: child,
    );

    if (useRepaintBoundary) {
      scrollView = RepaintBoundary(child: scrollView);
    }

    return scrollView;
  }
}
