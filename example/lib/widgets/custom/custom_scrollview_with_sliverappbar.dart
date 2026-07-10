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
