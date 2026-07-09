import '../generator.dart';

String pageTemplate(String mod, String cls, String pkg, GeneratorMode mode) {
  final hasSearch = mode != GeneratorMode.minimal;
  final hasFilter = mode == GeneratorMode.full;

  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:$pkg/constants/enums.dart';
import 'package:$pkg/modules/$mod/components/${mod}_card.dart';
import 'package:$pkg/modules/$mod/controllers/${mod}_controller.dart';
import 'package:$pkg/modules/tickets/components/ticket_list_shimmer.dart';
import 'package:$pkg/resources/app_string.dart';
import 'package:$pkg/utils/dimens.dart';
import 'package:$pkg/widgets/common/app_error_widget.dart';
import 'package:$pkg/widgets/common/empty_state_page_new.dart';
import 'package:$pkg/widgets/custom/custom_refresh_indicator.dart';
import 'package:$pkg/widgets/custom/custom_scrollview_with_sliverappbar.dart';
${hasSearch ? "import 'package:$pkg/widgets/common/search_history_panel.dart';" : ''}
${hasSearch ? "import 'package:$pkg/modules/$mod/components/${mod}_app_bar.dart';" : ''}
${hasFilter ? "import 'package:$pkg/modules/$mod/components/${mod}_appbar_filter.dart';" : ''}

class ${cls}Page extends StatelessWidget {
  const ${cls}Page({super.key});

  @override
  Widget build(BuildContext context) => ${hasSearch ? '''PopScope(
    onPopInvokedWithResult: (_, _) => ${cls}Controller.find.onBackPressed(),
    child: ''' : ''}Scaffold(
    body: GetBuilder<${cls}Controller>(
      builder: (controller) {
        if (controller.loadingStatus == .error) {
          return AppErrorWidget(onRetryTap: controller.onRetryTap);
        }
        return ${hasSearch ? '''Stack(
          children: [
            ''' : ''}CustomRefreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollViewWithSliverAppBar(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: controller.scroll,
            appBar: ${hasSearch ? '${cls}AppBar(controller: controller)' : 'AppBar(title: Text(AppString.$mod.tr))'},
            filterWidget: ${hasFilter ? '(controller.isInitialLoaded && !controller.isSearchFieldVisible)\n                    ? ${cls}AppbarFilter(controller: controller)\n                    : null' : 'null'},
            slivers: [
              if (controller.loadingStatus == .loading)
                const _LoadingView()
              else if (controller.loadingStatus == .done && controller.hasData)
                _${cls}CardList(controller: controller)
              else if (!controller.hasData && controller.loadingStatus == .done)
                _EmptyView(controller: controller),
              if (controller.isMoreLoading == .loading) const _LoadMoreView(),
            ],
          ),
        )${hasSearch ? ''',
            if (controller.isSearchFieldVisible)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                bottom: 0,
                child: SearchHistoryPanel(
                  historyKey: ${cls}Controller.historyKey,
                  visible: controller.isHistoryVisible,
                  query: controller.searchFieldController.text,
                  onItemTap: controller.onHistoryItemTap,
                ),
              ),
          ],
        )''' : ''};
      },
    ),
  )${hasSearch ? '\n  )' : ''};
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.controller});
  final ${cls}Controller controller;

  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    fillOverscroll: true,
    child: EmptyStatePage(
      message: AppString.noDataFound.trParams({'key': ''}),
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
      itemBuilder: (_, _) => const TicketListCardTileShimmer(),
    ),
  );
}

class _${cls}CardList extends StatelessWidget {
  const _${cls}CardList({required this.controller});
  final ${cls}Controller controller;

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace childCount with controller.items.length
    delegate: SliverChildBuilderDelegate(
      (_, i) => const ${cls}Card(),
      childCount: 0,
    ),
  );
}

class _LoadMoreView extends StatelessWidget {
  const _LoadMoreView();

  @override
  Widget build(BuildContext context) => SliverList.builder(
    itemCount: 1,
    itemBuilder: (_, _) => const TicketListCardTileShimmer(),
  );
}
''';
}
