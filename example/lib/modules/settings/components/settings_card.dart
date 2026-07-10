import 'package:flutter/material.dart';
import 'package:example/utils/dimens.dart';
// TODO: import your model
// import 'package:example/modules/settings/models/settings_model.dart';

/// Card widget for displaying a single Settings item in a list.
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    this.onTap,
    // TODO: required this.model,
  });

  final VoidCallback? onTap;
  // TODO: final SettingsModel model;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.sixTeen, vertical: Dimens.four),
      padding: EdgeInsets.all(Dimens.sixTeen),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimens.eight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: replace with your model fields
          Text('Item Title', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: Dimens.four),
          Text('Item subtitle or description', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}
