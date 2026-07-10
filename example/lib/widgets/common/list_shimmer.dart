import 'package:flutter/material.dart';

class CommonListShimmer extends StatelessWidget {
  const CommonListShimmer({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Loading...'),
  );
}
