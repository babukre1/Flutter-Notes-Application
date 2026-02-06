import 'package:flutter/material.dart';
import 'package:notes_application/api_client.dart';
import 'package:notes_application/login.dart';

void main() async {
  // Add async here
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize ApiClient
    ApiClient.init();

    runApp(const NotesApp());
  } catch (e) {
    // print("CRITICAL BOOT ERROR: $e");
    // Still run the app so you can at least see a blank screen or error
    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text("App failed to start"))),
      ),
    );
  }
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
