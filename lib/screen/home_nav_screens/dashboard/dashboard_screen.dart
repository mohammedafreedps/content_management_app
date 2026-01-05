import 'package:content_managing_app/firebase_funtions/firebase_auth_funtions.dart';
import 'package:content_managing_app/screen/home_nav_screens/dashboard/widgets/calender_view/calender_view.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(AppSpacing.screenPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseAuthFunction.instance.signOut();
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                CalenderView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
