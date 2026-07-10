// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/constants/enums.dart';
// TODO: import your card widget
import 'package:example/modules/auth/controllers/auth_login_controller.dart';
import 'package:example/widgets/common/list_shimmer.dart';
import 'package:example/utils/dimens.dart';
import 'package:example/widgets/common/app_error_widget.dart';
import 'package:example/widgets/common/empty_state_page_new.dart';
import 'package:example/resources/app_string.dart';
import 'package:example/widgets/custom/custom_refresh_indicator.dart';
import 'package:example/widgets/custom/custom_scrollview_with_sliverappbar.dart';

class AuthLoginPage extends StatelessWidget {
  const AuthLoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GetBuilder<AuthLoginController>(
      builder: (controller) {
        if (controller.loadingStatus == LoadingStatus.error) {
          return AppErrorWidget(onRetryTap: controller.onRetryTap);
        }
        return CustomRefreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollViewWithSliverAppBar(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: controller.scroll,
            appBar: AppBar(title: const Text('AuthLogin')),
            filterWidget: null,
            slivers: [
              if (controller.loadingStatus == LoadingStatus.loading)
                const _LoadingView()
              else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                const _AuthLoginContent()
              else if (!controller.hasData && controller.loadingStatus == LoadingStatus.done)
                _EmptyView(controller: controller),
              if (controller.isMoreLoading == LoadingStatus.loading) const _LoadMoreView(),
            ],
          ),
        );
      },
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.controller});
  final AuthLoginController controller;

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

class _AuthLoginContent extends StatelessWidget {
  const _AuthLoginContent();

  @override
  Widget build(BuildContext context) => SliverList(
    // TODO: replace with your list items
    delegate: SliverChildBuilderDelegate((_, i) => const Placeholder(), childCount: 0),
  );
}

class _LoadMoreView extends StatelessWidget {
  const _LoadMoreView();

  @override
  Widget build(BuildContext context) => SliverList.builder(itemCount: 1, itemBuilder: (_, _) => const CommonListShimmer());
}
