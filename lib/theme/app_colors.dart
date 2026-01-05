import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color calendarActive;
  final Color calendarInactive;

  const AppColors({

    required this.calendarActive,
    required this.calendarInactive,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? calendarActive,
    Color? calendarInactive,
  }) {
    return AppColors(
      calendarActive: calendarActive ?? this.calendarActive,
      calendarInactive: calendarInactive ?? this.calendarInactive,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      calendarActive:
          Color.lerp(calendarActive, other.calendarActive, t)!,
      calendarInactive:
          Color.lerp(calendarInactive, other.calendarInactive, t)!,
    );
  }
}
