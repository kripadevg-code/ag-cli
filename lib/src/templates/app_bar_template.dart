String appBarTemplate(String mod, String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:$pkg/extensions/text_theme_extension.dart';
import 'package:$pkg/modules/$mod/controllers/${mod}_controller.dart';
import 'package:$pkg/resources/app_string.dart';
import 'package:$pkg/resources/assets_manager.dart';
import 'package:$pkg/utils/dimens.dart';
import 'package:$pkg/widgets/custom/custom_app_bar.dart';
import 'package:$pkg/widgets/custom/primary_icon_btn.dart';

class ${cls}AppBar extends StatelessWidget implements PreferredSizeWidget {
  const ${cls}AppBar({super.key, required this.controller});
  final ${cls}Controller controller;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
    ),
    child: controller.isSearchFieldVisible
        ? _SearchBar(
            key: const ValueKey('search'),
            controller: controller.searchFieldController,
            focusNode: controller.searchFocusNode,
            onBackTap: controller.onBackPressed,
            onChanged: controller.onSearchFieldChanged,
            onSubmitted: controller.onSubmit,
            onClearTap: controller.onClearSearch,
          )
        : Obx(() {
            final hasFilter = controller.filterAppBarText.value != null;
            return _NormalBar(
              key: const ValueKey('normal'),
              title: controller.filterAppBarText.value,
              hasFilter: hasFilter,
              onSearchTap: () => controller.isSearchFieldVisible = true,
              onCalendarTap: hasFilter
                  ? controller.onClearTimeFilterTap
                  : controller.goToCustomTimeFilterPage,
            );
          }),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NormalBar extends StatelessWidget {
  const _NormalBar({
    super.key,
    this.title,
    required this.hasFilter,
    this.onSearchTap,
    this.onCalendarTap,
  });
  final String? title;
  final bool hasFilter;
  final VoidCallback? onSearchTap, onCalendarTap;

  @override
  Widget build(BuildContext context) => InfraonAppBar(
    title: title ?? AppString.$mod.tr,
    fontSize: Dimens.twenty,
    actions: [
      InfraonAppIconButton(
        isVisible: !hasFilter,
        onTap: onSearchTap,
        svgIcon: ImageAssets.searchIcon,
        scale: 1.1,
      ),
      InfraonAppIconButton(
        icon: hasFilter ? Icons.clear_rounded : Icons.calendar_today_rounded,
        iconSize: hasFilter ? Dimens.twenty : Dimens.sixTeen,
        scale: 1.2,
        onTap: onCalendarTap,
      ),
    ],
  );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onBackTap,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClearTap,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onBackTap, onClearTap;
  final ValueChanged<String> onChanged, onSubmitted;

  @override
  Widget build(BuildContext context) => AppBar(
    leadingWidth: 0,
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InfraonAppIconButton(
          onTap: onBackTap,
          icon: GetPlatform.isAndroid
              ? Icons.arrow_back_rounded
              : Icons.arrow_back_ios_new_rounded,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppString.searchByIDorRequester.tr,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: Dimens.onlyTop16,
              isDense: true,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, v, _) => InfraonAppIconButton(
                  isVisible: v.text.isNotEmpty,
                  icon: Icons.close,
                  scale: 0.9,
                  iconColor: Theme.of(context).labelSmallColor,
                  onTap: onClearTap,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
''';

String appBarFilterTemplate(String mod, String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:$pkg/modules/$mod/controllers/${mod}_controller.dart';
import 'package:$pkg/modules/tickets/components/filter_tag.dart';
import 'package:$pkg/utils/dimens.dart';

class ${cls}AppbarFilter extends StatelessWidget {
  const ${cls}AppbarFilter({super.key, required this.controller});
  final ${cls}Controller controller;

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
        return FilterTag(
          alignment: Alignment.center,
          title: model.name,
          isSelected: model.isSelected,
          onFilterTap: () => controller.onTopFilterTap(i),
          isLeftMargin: i == 0,
        );
      },
    ),
  );
}
''';
