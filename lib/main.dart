import 'package:flutter/material.dart';
import 'input_screen.dart';
import 'result_screen.dart';

// Renamed MyApp to LoanApp for better context
class LoanApp extends StatelessWidget {
  const LoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Eligibility Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Set the default input border style
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
      // Define the named routes
      initialRoute: '/',
      routes: {
        '/': (context) => const InputScreen(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}

void main() {
  runApp(const LoanApp());
}