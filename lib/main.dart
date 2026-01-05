import 'package:content_managing_app/firebase_funtions/firebase_auth_funtions.dart';
import 'package:content_managing_app/firebase_options.dart';
import 'package:content_managing_app/screen/home_screen/home_screen.dart';
import 'package:content_managing_app/screen/login_signup/cubit/login/login_cubit.dart';
import 'package:content_managing_app/screen/login_signup/cubit/signup/signup_cubit.dart';
import 'package:content_managing_app/screen/login_signup/login_signup.dart';
import 'package:content_managing_app/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your BlocProviders here
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SignupCubit()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 13, 71, 21),
            onPrimary: Color.fromARGB(255, 13, 71, 21),
            secondary: Color.fromARGB(255, 102, 102, 102),
            onSecondary: Color.fromARGB(255, 13, 71, 21),
            error: Color.fromARGB(255, 250, 104, 104),
            onError: Color.fromARGB(255, 252, 248, 248),
            surface: Color.fromARGB(255, 235, 244, 221),
            onSurface: Color.fromARGB(255, 13, 71, 21),
          ),
          textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme)
              .apply(
                bodyColor: const Color.fromARGB(255, 13, 71, 21),
                displayColor: const Color.fromARGB(255, 13, 71, 21),
              ),
              extensions: const[
                AppColors(
                  calendarActive: Color.fromARGB(255, 233, 238, 217),
                  calendarInactive: Colors.transparent
                )
              ]
        ),
        title: 'Content Managing App',
        home: StreamBuilder<bool>(
          stream: FirebaseAuthFunction.instance.authStateStream(),
          builder: (context, snapshot) {
            // 🔄 Waiting for Firebase response
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 🔐 Logged in
            if (snapshot.data == true) {
              return HomeScreen();
            }

            // 🚪 Logged out
            return LoginSignupScreen();
          },
        ),
      ),
    );
  }
}

extension ThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>()!;
}