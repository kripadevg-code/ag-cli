import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/modules/settings/controllers/settings_controller.dart';
import 'package:example/utils/dimens.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key, required this.controller});
  final SettingsController controller;

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
              onCalendarTap: hasFilter ? controller.onClearTimeFilterTap : controller.goToCustomTimeFilterPage,
            );
          }),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NormalBar extends StatelessWidget {
  const _NormalBar({super.key, this.title, required this.hasFilter, this.onSearchTap, this.onCalendarTap});
  final String? title;
  final bool hasFilter;
  final VoidCallback? onSearchTap, onCalendarTap;

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title ?? 'Settings'),
    actions: [
      if (!hasFilter) IconButton(onPressed: onSearchTap, icon: const Icon(Icons.search)),
      IconButton(icon: Icon(hasFilter ? Icons.clear_rounded : Icons.calendar_today_rounded), onPressed: onCalendarTap),
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
        IconButton(onPressed: onBackTap, icon: Icon(GetPlatform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios_new_rounded)),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: Dimens.onlyTop16,
              isDense: true,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, v, _) =>
                    v.text.isNotEmpty ? IconButton(icon: const Icon(Icons.close), onPressed: onClearTap) : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
