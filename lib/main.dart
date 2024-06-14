import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PL04App());
}

class PL04App extends StatelessWidget {
  const PL04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PL04App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 68, 91, 166)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
