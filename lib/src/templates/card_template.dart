String cardTemplate(String mod, String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:$pkg/utils/dimens.dart';
import 'package:$pkg/widgets/resusable/inicident_card.dart';
// TODO: import your model
// import 'package:$pkg/modules/$mod/models/${mod}_model.dart';

class ${cls}Card extends StatelessWidget {
  const ${cls}Card({
    super.key,
    this.onTap,
    this.onTakeItTap,
    this.index = 0,
    // TODO: required this.model,
  });

  final VoidCallback? onTap;
  final VoidCallback? onTakeItTap;
  final int index;
  // TODO: final ${cls}Model model;

  @override
  Widget build(BuildContext context) => IncidentCard(
    onTap: onTap,
    displayId: null,        // TODO: model.displayId
    displayTitle: null,     // TODO: model.title / summary
    priorityText: null,     // TODO: model.priority?.name
    statusText: null,       // TODO: model.status?.name
    creationTime: null,     // TODO: model.creationTime
    avtarText: null,
    assigneeName: null,
    incidentTypeColor: null,
    priorityBgColor: null,
    priorityTextColor: null,
    statusBgColor: null,
    statusTextColor: null,
    assigneeAvtarColor: null,
    isBorderColor: false,
    isShowTakeIt: true,
    onTakeItTap: onTakeItTap,
    margin: Dimens.defaultPadding.copyWith(bottom: Dimens.six, top: Dimens.four),
  );
}
''';
