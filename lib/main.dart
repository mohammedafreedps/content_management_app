import 'package:content_managing_app/firebase_funtions/firebase_auth_funtions.dart';
import 'package:content_managing_app/firebase_options.dart';
import 'package:content_managing_app/screen/login_signup/login_signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 13, 71, 21),
          onPrimary: Color.fromARGB(255, 27, 33, 26),
          secondary: Color.fromARGB(255, 102, 102, 102),
          onSecondary: Color.fromARGB(255, 13, 71, 21),
          error: Color.fromARGB(255, 204, 8, 8),
          onError: Color.fromARGB(255, 252, 248, 248),
          surface: Color.fromARGB(255, 235, 244, 221),
          onSurface: Color.fromARGB(255, 13, 71, 21),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme,),
        
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
            return const Scaffold(
              body: Center(child: Text('User is logged in')),
            );
          }

          // 🚪 Logged out
          return LoginSignupScreen();
        },
      ),
    );
  }
}
