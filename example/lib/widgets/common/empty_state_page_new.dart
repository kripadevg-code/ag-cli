import 'package:flutter/material.dart';

class EmptyStatePage extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;
  final bool asWidget;

  const EmptyStatePage({super.key, required this.message, required this.onRefresh, this.asWidget = false});

  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}
