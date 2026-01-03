import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLoginSection = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (isLoginSection) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  TextField(decoration: InputDecoration(hintText: 'e-mail'),controller: emailController,),
                  SizedBox(height: AppSpacing.md),
                  TextField(decoration: InputDecoration(hintText: 'password'),controller: passwordController,),
                  SizedBox(height: AppSpacing.xl),
                  ElevatedButton(onPressed: () {}, child: Text('Login')),
                  SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginSection = false;
                      });
                    },
                    child: Text('Signup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Column(
                children: [
                  Text(
                    'Signup',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  TextField(decoration: InputDecoration(hintText: 'Full name'), controller: nameController),
                  SizedBox(height: AppSpacing.md),
                  TextField(decoration: InputDecoration(hintText: 'e-mail'), controller: emailController,),
                  SizedBox(height: AppSpacing.md),
                  TextField(decoration: InputDecoration(hintText: 'password'), controller: passwordController),
                  SizedBox(height: AppSpacing.md),
                  TextField(decoration: InputDecoration(hintText: 'comfirm password'),controller: comfirmPasswordController,),
                  SizedBox(height: AppSpacing.xl),
                  ElevatedButton(onPressed: () {}, child: Text('Signup')),
                  SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginSection = true;
                      });
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
          ],
        ),
        ),
      );
    }
  }
}
