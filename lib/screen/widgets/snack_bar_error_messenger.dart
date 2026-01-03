import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

void snackBarErrorMessage({
  required BuildContext context,
  required String message,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onError,
          ),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
}
