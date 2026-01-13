import 'package:content_managing_app/screen/widgets/snack_bar_error_messenger.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_auth_funtions.dart';
import 'package:content_managing_app/services/media_cache_service.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('Data & cache'),
                Opacity(opacity: 0.2, child: Divider()),
                Container(
                  decoration: BoxDecoration(),
                  child: TextButton(
                    onPressed: () {
                      MediaCacheService.instance.clearAll();
                      snackBarErrorMessage(
                        context: context,
                        message: 'Media cache cleared',
                      );
                    },
                    child: Text('Clear Cache'),
                  ),
                ),
                Opacity(opacity: 0.2, child: Divider()),
                Text('Account'),
                Opacity(opacity: 0.2, child: Divider()),
                Container(
                  decoration: BoxDecoration(),
                  child: TextButton(
                    onPressed: () {
                      FirebaseAuthFunction.instance.signOut();
                    },
                    child: Text('Log out'),
                  ),
                ),
                Opacity(opacity: 0.2, child: Divider()),
              ],
            ),
            Text('by Mohammed Afreed',style: Theme.of(context).textTheme.bodySmall,)
          ],
        ),
      ),
    );
  }
}
