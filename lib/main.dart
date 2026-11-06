import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/app_constants.dart';
import 'screens/auth_gate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LakbayNasugbuApp());
}

class LakbayNasugbuApp extends StatelessWidget {
  const LakbayNasugbuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LakbayNasugbu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: warmCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: oceanTeal,
          primary: oceanTeal,
          secondary: deepTeal,
          surface: warmCream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: warmCream,
          foregroundColor: deepTeal,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: oceanTeal,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}



