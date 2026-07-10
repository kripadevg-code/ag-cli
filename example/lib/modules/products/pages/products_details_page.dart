// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/constants/enums.dart';
// TODO: import your card widget
import 'package:example/modules/products/controllers/products_details_controller.dart';
import 'package:example/widgets/common/list_shimmer.dart';
import 'package:example/utils/dimens.dart';
import 'package:example/widgets/common/app_error_widget.dart';
import 'package:example/widgets/common/empty_state_page_new.dart';
import 'package:example/resources/app_string.dart';
import 'package:example/widgets/custom/custom_refresh_indicator.dart';
import 'package:example/widgets/custom/custom_scrollview_with_sliverappbar.dart';

class ProductsDetailsPage extends StatelessWidget {
  const ProductsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GetBuilder<ProductsDetailsController>(
      builder: (controller) {
        if (controller.loadingStatus == LoadingStatus.error) {
          return AppErrorWidget(onRetryTap: controller.onRetryTap);
        }
        return CustomRefreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollViewWithSliverAppBar(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: controller.scroll,
            appBar: AppBar(title: const Text('ProductsDetails')),
            filterWidget: null,
            slivers: [
              if (controller.loadingStatus == LoadingStatus.loading)
                const _LoadingView()
              else if (controller.loadingStatus == LoadingStatus.done && controller.hasData)
                const _ProductsDetailsContent()
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
  final ProductsDetailsController controller;

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

class _ProductsDetailsContent extends StatelessWidget {
  const _ProductsDetailsContent();

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
