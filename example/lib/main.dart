import 'package:flutter/material.dart';
import 'package:uniform_example/login_page.dart';

void main() {
  runApp(const UniformExampleApp());
}

class UniformExampleApp extends StatelessWidget {
  const UniformExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(),
    );

    return MaterialApp(
      title: 'Uniform Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
        inputDecorationTheme: inputDecorationTheme,
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: inputDecorationTheme,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
