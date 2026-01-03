import 'package:content_managing_app/screen/login_signup/cubit/login/login_cubit.dart';
import 'package:content_managing_app/screen/login_signup/cubit/signup/signup_cubit.dart';
import 'package:content_managing_app/screen/widgets/snack_bar_error_messenger.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLoginSection = true;

  // 🔐 Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'e-mail',
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LogInErrorState) {
                        snackBarErrorMessage(
                          context: context,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LogInLoadingState) {
                        return const CircularProgressIndicator();
                      }

                      return ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            snackBarErrorMessage(
                              context: context,
                              message: 'Please fill in all fields',
                            );
                            return;
                          }

                          context.read<LoginCubit>().logInButtonPressed(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                        child: const Text('Login'),
                      );
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginSection = false;
                      });
                    },
                    child: const Text('Signup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // ---------------- SIGNUP ----------------

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

                // Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'e-mail',
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Confirm Password
                TextField(
                  controller: comfirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'confirm password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                BlocConsumer<SignupCubit, SignupState>(
                  listener: (context, state) {
                    if (state is SignupErrorState) {
                      snackBarErrorMessage(
                        context: context,
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SignupLoadingState) {
                      return const CircularProgressIndicator();
                    }

                    return ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            comfirmPasswordController.text.isEmpty) {
                          snackBarErrorMessage(
                            context: context,
                            message: 'Please fill in all fields',
                          );
                          return;
                        }

                        if (passwordController.text !=
                            comfirmPasswordController.text) {
                          snackBarErrorMessage(
                            context: context,
                            message: 'Passwords do not match',
                          );
                          return;
                        }

                        context.read<SignupCubit>().signUpButtonPressed(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                      },
                      child: const Text('Signup'),
                    );
                  },
                ),

                SizedBox(height: AppSpacing.lg),

                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginSection = true;
                    });
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
