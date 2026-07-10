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
