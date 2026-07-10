import 'package:flutter/material.dart';
import 'package:example/modules/profile/controllers/profile_controller.dart';
import 'package:example/utils/dimens.dart';

class ProfileAppbarFilter extends StatelessWidget {
  const ProfileAppbarFilter({super.key, required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: Dimens.fourty,
    child: ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: controller.topFilterModels.length,
      itemBuilder: (_, i) {
        final model = controller.topFilterModels[i];
        return GestureDetector(
          onTap: () => controller.onTopFilterTap(i),
          child: Container(
            margin: EdgeInsets.only(left: i == 0 ? Dimens.sixTeen : 0, right: Dimens.eight),
            padding: EdgeInsets.symmetric(horizontal: Dimens.sixTeen),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: model.isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(Dimens.twenty),
            ),
            child: Text(model.name, style: TextStyle(color: model.isSelected ? Colors.white : Colors.black)),
          ),
        );
      },
    ),
  );
}
