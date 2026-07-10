// ignore_for_file: unused_import
import '../generator.dart';
import '../utils.dart';

/// Generates a page widget.
///
/// [mod]  — snake_case module folder (file is placed here)
/// [cls]  — PascalCase class name for this page widget
/// [pkg]  — Flutter package name
/// [mode] — GeneratorMode (full / search / minimal)
///
/// When [cls] == PascalCase([mod]) → module's own main page.
/// When [cls] != PascalCase([mod]) → secondary page inside the module,
///   uses [cls]Controller (not the module's controller).
String pageTemplate(String mod, String fileNamePrefix, String componentPath, String cls, String pkg, GeneratorMode mode) {
  final modCls = toPascal(mod); // e.g. "Orders"
  final isModulePage = cls == modCls; // true = OrdersPage, false = CheckoutPage inside orders/

  // Controller class always matches the page name (CheckoutPage → CheckoutController)
  final ctrlCls = cls;
  // Import path for the controller file always lives in the same module directory
  final ctrlMod = mod;

  final hasSearch = isModulePage && mode != GeneratorMode.minimal;
  final hasFilter = isModulePage && mode == GeneratorMode.full;

  // Imports
  final cardImport = isModulePage
      ? "import 'package:$pkg/modules/$mod/components/${componentPath.isEmpty ? "" : "$componentPath/"}${fileNamePrefix}_card.dart';"
      : '// TODO: import your card widget';
  final appBarImport = hasSearch
      ? "import 'package:$pkg/modules/$mod/components/${componentPath.isEmpty ? "" : "$componentPath/"}${fileNamePrefix}_app_bar.dart';"
      : '';
  final filterImport = hasFilter
      ? "import 'package:$pkg/modules/$mod/components/${componentPath.isEmpty ? "" : "$componentPath/"}${fileNamePrefix}_appbar_filter.dart';"
      : '';
  final historyImport = hasSearch ? "import 'package:$pkg/widgets/common/search_history_panel.dart';" : '';

  // AppBar
  final appBar = hasSearch ? '${ctrlCls}AppBar(controller: controller)' : "AppBar(title: const Text('$cls'))";

  // Filter widget
  final filterWidget = hasFilter
      ? '(controller.isInitialLoaded && !controller.isSearchFieldVisible)\n'
          '                    ? ${ctrlCls}AppbarFilter(controller: controller)\n'
          '                    : null'
      : 'null';

  // Card list sliver
  final cardSliver = isModulePage ? '_${cls}CardList(controller: controller)' : 'const _${cls}Content()';

  // Search overlay
  final searchOverlay = hasSearch
      ? '''
            if (controller.isSearchFieldVisible)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                bottom: 0,
                child: SearchHistoryPanel(
                  historyKey: ${ctrlCls}Controller.historyKey,
                  visible: controller.isHistoryVisible,
                  query: controller.searchFieldController.text,
                  onItemTap: controller.onHistoryItemTap,
                ),
              ),'''
      : '';

  // PopScope for search back-press
  final popOpen =
      hasSearch ? 'PopScope(\n    onPopInvokedWithResult: (_, _) => ${ctrlCls}Controller.find.onBackPressed(),\n    child: ' : '';
  final popClose = hasSearch ? '\n  )' : '';

  // Scaffold body
  final body = hasSearch
      ? '''Stack(
          children: [
            CustomRefreshIndicator(
              onRefresh: controller.onRefresh,
              child: CustomScrollViewWithSliverAppBar(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: controller.scroll,
                appBar: $appBar,
                filterWidget: $filterWidget,
                slivers: [
                  if (controller.loadingStatus == LoadingStatus.loading)
                    const _LoadingView()
                  else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                    $cardSliver
                  else if (!controller.hasData && controller.loadingStatus == LoadingStatus.done)
                    _EmptyView(controller: controller),
                  if (controller.isMoreLoading == LoadingStatus.loading) const _LoadMoreView(),
                ],
              ),
            ),$searchOverlay
          ],
        )'''
      : '''CustomRefreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollViewWithSliverAppBar(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: controller.scroll,
            appBar: $appBar,
            filterWidget: $filterWidget,
            slivers: [
              if (controller.loadingStatus == LoadingStatus.loading)
                const _LoadingView()
              else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                $cardSliver
              else if (!controller.hasData && controller.loadingStatus == LoadingStatus.done)
                _EmptyView(controller: controller),
              if (controller.isMoreLoading == LoadingStatus.loading) const _LoadMoreView(),
            ],
          ),
        )''';

  // List widget (card list or content stub)
  final listWidget = isModulePage
      ? '''class _${cls}CardList extends StatelessWidget {
  const _${cls}CardList({required this.controller});
  final ${ctrlCls}Controller controller;

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace childCount with controller.items.length
    delegate: SliverChildBuilderDelegate(
      (_, i) => const ${modCls}Card(),
      childCount: 0,
    ),
  );
}'''
      : '''class _${cls}Content extends StatelessWidget {
  const _${cls}Content();

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace with your list items
    delegate: SliverChildBuilderDelegate(
      (_, i) => const Placeholder(),
      childCount: 0,
    ),
  );
}''';

  return '''
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:$pkg/constants/enums.dart';
$cardImport
import 'package:$pkg/modules/$ctrlMod/controllers/${toSnake(cls)}_controller.dart';
import 'package:$pkg/widgets/common/list_shimmer.dart';
import 'package:$pkg/utils/dimens.dart';
import 'package:$pkg/widgets/common/app_error_widget.dart';
import 'package:$pkg/widgets/common/empty_state_page_new.dart';
import 'package:$pkg/resources/app_string.dart';
import 'package:$pkg/widgets/custom/custom_refresh_indicator.dart';
import 'package:$pkg/widgets/custom/custom_scrollview_with_sliverappbar.dart';
$historyImport
$appBarImport
$filterImport

class ${cls}Page extends StatelessWidget {
  const ${cls}Page({super.key});

  @override
  Widget build(BuildContext context) => ${popOpen}Scaffold(
    body: GetBuilder<${ctrlCls}Controller>(
      builder: (controller) {
        if (controller.loadingStatus == LoadingStatus.error) {
          return AppErrorWidget(onRetryTap: controller.onRetryTap);
        }
        return $body;
      },
    ),
  )$popClose;
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.controller});
  final ${ctrlCls}Controller controller;

  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    fillOverscroll: true,
    child: EmptyStatePage(
      message: AppString.noDataFound,
      onRefresh: controller.onRefresh,
      asWidget: true,
    ),
  );
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: Dimens.onlyTop12,
    sliver: SliverList.builder(
      itemCount: 5,
      itemBuilder: (_, _) => const CommonListShimmer(),
    ),
  );
}

$listWidget

class _LoadMoreView extends StatelessWidget {
  const _LoadMoreView();

  @override
  Widget build(BuildContext context) => SliverList.builder(
    itemCount: 1,
    itemBuilder: (_, _) => const CommonListShimmer(),
  );
}
''';
}
