import 'package:content_managing_app/main.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DaysToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function onTap;
  const DaysToggleButton({super.key, required this.isActive, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive
              ? context.appColors.calendarActive
              : context.appColors.calendarInactive,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.md),topRight: Radius.circular(AppRadius.md) ),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
