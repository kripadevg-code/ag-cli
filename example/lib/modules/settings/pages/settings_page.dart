// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/constants/enums.dart';
import 'package:example/modules/settings/components/settings_card.dart';
import 'package:example/modules/settings/controllers/settings_controller.dart';
import 'package:example/widgets/common/list_shimmer.dart';
import 'package:example/utils/dimens.dart';
import 'package:example/widgets/common/app_error_widget.dart';
import 'package:example/widgets/common/empty_state_page_new.dart';
import 'package:example/resources/app_string.dart';
import 'package:example/widgets/custom/custom_refresh_indicator.dart';
import 'package:example/widgets/custom/custom_scrollview_with_sliverappbar.dart';
import 'package:example/widgets/common/search_history_panel.dart';
import 'package:example/modules/settings/components/settings_app_bar.dart';
import 'package:example/modules/settings/components/settings_appbar_filter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (_, _) => SettingsController.find.onBackPressed(),
    child: Scaffold(
      body: GetBuilder<SettingsController>(
        builder: (controller) {
          if (controller.loadingStatus == LoadingStatus.error) {
            return AppErrorWidget(onRetryTap: controller.onRetryTap);
          }
          return Stack(
            children: [
              CustomRefreshIndicator(
                onRefresh: controller.onRefresh,
                child: CustomScrollViewWithSliverAppBar(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: controller.scroll,
                  appBar: SettingsAppBar(controller: controller),
                  filterWidget: (controller.isInitialLoaded && !controller.isSearchFieldVisible)
                      ? SettingsAppbarFilter(controller: controller)
                      : null,
                  slivers: [
                    if (controller.loadingStatus == LoadingStatus.loading)
                      const _LoadingView()
                    else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                      _SettingsCardList(controller: controller)
                    else if (!controller.hasData && controller.loadingStatus == LoadingStatus.done)
                      _EmptyView(controller: controller),
                    if (controller.isMoreLoading == LoadingStatus.loading) const _LoadMoreView(),
                  ],
                ),
              ),
              if (controller.isSearchFieldVisible)
                Positioned(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SearchHistoryPanel(
                    historyKey: SettingsController.historyKey,
                    visible: controller.isHistoryVisible,
                    query: controller.searchFieldController.text,
                    onItemTap: controller.onHistoryItemTap,
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    fillOverscroll: true,
    child: EmptyStatePage(message: AppString.noDataFound, onRefresh: controller.onRefresh, asWidget: true),
  );
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: Dimens.onlyTop12,
    sliver: SliverList.builder(itemCount: 5, itemBuilder: (_, _) => const CommonListShimmer()),
  );
}

class _SettingsCardList extends StatelessWidget {
  const _SettingsCardList({required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace childCount with controller.items.length
    delegate: SliverChildBuilderDelegate((_, i) => const SettingsCard(), childCount: 0),
  );
}

class _LoadMoreView extends StatelessWidget {
  const _LoadMoreView();

  @override
  Widget build(BuildContext context) => SliverList.builder(itemCount: 1, itemBuilder: (_, _) => const CommonListShimmer());
}
