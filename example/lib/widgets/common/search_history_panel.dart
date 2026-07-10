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
