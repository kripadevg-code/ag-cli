// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/constants/enums.dart';
import 'package:example/modules/profile/components/profile_card.dart';
import 'package:example/modules/profile/controllers/profile_controller.dart';
import 'package:example/widgets/common/list_shimmer.dart';
import 'package:example/utils/dimens.dart';
import 'package:example/widgets/common/app_error_widget.dart';
import 'package:example/widgets/common/empty_state_page_new.dart';
import 'package:example/resources/app_string.dart';
import 'package:example/widgets/custom/custom_refresh_indicator.dart';
import 'package:example/widgets/custom/custom_scrollview_with_sliverappbar.dart';
import 'package:example/widgets/common/search_history_panel.dart';
import 'package:example/modules/profile/components/profile_app_bar.dart';
import 'package:example/modules/profile/components/profile_appbar_filter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (_, _) => ProfileController.find.onBackPressed(),
    child: Scaffold(
      body: GetBuilder<ProfileController>(
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
                  appBar: ProfileAppBar(controller: controller),
                  filterWidget: (controller.isInitialLoaded && !controller.isSearchFieldVisible)
                      ? ProfileAppbarFilter(controller: controller)
                      : null,
                  slivers: [
                    if (controller.loadingStatus == LoadingStatus.loading)
                      const _LoadingView()
                    else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                      _ProfileCardList(controller: controller)
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
                    historyKey: ProfileController.historyKey,
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
  final ProfileController controller;

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

class _ProfileCardList extends StatelessWidget {
  const _ProfileCardList({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace childCount with controller.items.length
    delegate: SliverChildBuilderDelegate((_, i) => const ProfileCard(), childCount: 0),
  );
}

class _LoadMoreView extends StatelessWidget {
  const _LoadMoreView();

  @override
  Widget build(BuildContext context) => SliverList.builder(itemCount: 1, itemBuilder: (_, _) => const CommonListShimmer());
}
