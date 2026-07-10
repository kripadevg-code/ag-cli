/// Templates for common architectural widgets and helpers.
library;

String queryHelperStub() => '''
/// Helper for building API query filters.
abstract class QueryHelper {
  static List<Map<String, dynamic>> getSearchFilterQuery(String query) {
    return []; // TODO: implement search filter
  }
}
''';

String searchHistoryServiceStub() => '''
/// Local storage service for search history.
abstract class SearchHistoryService {
  static void add(String key, String query) {}
  static List<String> getHistory(String key) => [];
  static void clear(String key) {}
}
''';

String appStringStub() => '''
/// Centralized app strings.
///
/// TODO: Replace with your actual string keys and translations.
abstract class AppString {
  static const noDataFound = 'no_data_found';
  // TODO: add your module-specific string keys here
  // static const myModule = 'My Module';
}
''';

String appErrorWidgetStub() => '''
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final VoidCallback onRetryTap;
  const AppErrorWidget({super.key, required this.onRetryTap});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Something went wrong.'),
        ElevatedButton(onPressed: onRetryTap, child: const Text('Retry')),
      ],
    ),
  );
}
''';

String emptyStatePageStub() => '''
import 'package:flutter/material.dart';

class EmptyStatePage extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;
  final bool asWidget;

  const EmptyStatePage({
    super.key,
    required this.message,
    required this.onRefresh,
    this.asWidget = false,
  });

  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}
''';

String customRefreshIndicatorStub() => '''
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: child,
  );
}
''';

String customScrollViewStub() => '''
import 'package:flutter/material.dart';

class CustomScrollViewWithSliverAppBar extends StatelessWidget {
  final ScrollPhysics physics;
  final ScrollController? controller;
  final Widget appBar;
  final Widget? filterWidget;
  final List<Widget> slivers;

  const CustomScrollViewWithSliverAppBar({
    super.key,
    required this.physics,
    this.controller,
    required this.appBar,
    this.filterWidget,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      controller: controller,
      slivers: [
        SliverToBoxAdapter(child: appBar),
        if (filterWidget != null) SliverToBoxAdapter(child: filterWidget),
        ...slivers,
      ],
    );
  }
}
''';

String searchHistoryPanelStub() => '''
import 'package:flutter/material.dart';

class SearchHistoryPanel extends StatelessWidget {
  final String historyKey;
  final bool visible;
  final String query;
  final void Function(String) onItemTap;

  const SearchHistoryPanel({
    super.key,
    required this.historyKey,
    required this.visible,
    required this.query,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Container(color: Colors.white, child: const Text('Search History'));
  }
}
''';

String responseExtensionStub() => '''
// Extensions for API responses.
''';

String stateModelStub() => '''
/// Generic state model for filters.
class StateModel {
  int id;
  String name;
  bool isSelected;

  StateModel({required this.id, required this.name, this.isSelected = false});
}
''';

String listShimmerStub() => '''
import 'package:flutter/material.dart';

class CommonListShimmer extends StatelessWidget {
  const CommonListShimmer({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Loading...'),
  );
}
''';

String incidentCardStub() => '''
import 'package:flutter/material.dart';

/// A generic, reusable card widget for list items.
///
/// Customize fields and styling to match your design system.
class ItemCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;
  final String? trailingText;
  final Color? accentColor;
  final EdgeInsetsGeometry? margin;

  const ItemCard({
    super.key,
    this.onTap,
    this.title,
    this.subtitle,
    this.trailingText,
    this.accentColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        border: accentColor != null
            ? Border(left: BorderSide(color: accentColor!, width: 4))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ],
            ),
          ),
          if (trailingText != null)
            Text(trailingText!, style: TextStyle(color: accentColor ?? Colors.grey, fontSize: 12)),
        ],
      ),
    ),
  );
}
''';
