import 'package:flutter/material.dart';
import 'package:uniform_example/login_page.dart';

void main() {
  runApp(const UniformExampleApp());
}

class UniformExampleApp extends StatelessWidget {
  const UniformExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uniform Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.green.withAlpha(20),
          filled: true,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
