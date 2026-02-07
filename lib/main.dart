import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notes_application/services/api_client.dart';
import 'package:notes_application/views/login.dart';

void main() async {
  // Add async here
  WidgetsFlutterBinding.ensureInitialized();
  debugProfileBuildsEnabled = true;
  debugProfilePaintsEnabled = true;

  ApiClient.init();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // Ensure Inter is added to pubspec.yaml
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE96A25),
          primary: const Color(0xFFE96A25),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
