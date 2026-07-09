String componentTemplate(String mod, String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:$pkg/utils/dimens.dart';

/// $cls component widget.
///
/// TODO: Customize the build method with your UI.
class $cls extends StatelessWidget {
  const $cls({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: Dimens.defaultPadding,
    child: const Placeholder(
      // TODO: replace with your widget tree
    ),
  );
}
''';
