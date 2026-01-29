import 'package:flutter/material.dart';
import 'package:time_widgets/screens/temp_schedule_manage_screen.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/widgets/dialogs/day_schedule_change_dialog.dart';
import 'package:time_widgets/widgets/dialogs/period_schedule_change_dialog.dart';

class TempScheduleMenuDialog extends StatelessWidget {
  const TempScheduleMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocalizationService.getString('temp_schedule_change')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.today_outlined),
            title: Text(LocalizationService.getString('change_by_day')),
            subtitle: Text(LocalizationService.getString('change_by_day_desc')),
            onTap: () {
              Navigator.pop(context); // Close menu
              showDialog<void>(
                context: context,
                builder: (context) => const DayScheduleChangeDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: Text(LocalizationService.getString('change_by_period')),
            subtitle: Text(LocalizationService.getString('change_by_period_desc')),
            onTap: () {
              Navigator.pop(context); // Close menu
              showDialog<void>(
                context: context,
                builder: (context) => const PeriodScheduleChangeDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.manage_history_outlined),
            title: Text(LocalizationService.getString('manage_temp_changes')),
            subtitle: Text(LocalizationService.getString('manage_temp_changes_desc')),
            onTap: () {
              Navigator.pop(context); // Close menu
              showDialog<void>(
                context: context,
                builder: (context) => const Dialog.fullscreen(
                  child: TempScheduleManageScreen(),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocalizationService.getString('cancel')),
        ),
      ],
    );
  }
}
