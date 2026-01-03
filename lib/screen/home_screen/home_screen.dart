import 'package:content_managing_app/firebase_funtions/firebase_auth_funtions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {
          await FirebaseAuthFunction.instance.signOut();
        }, child: Text('logout')),
      ),
    );
  }
}