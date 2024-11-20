import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(BankingAssistantApp());
}

class BankingAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Банковский помощник',
      theme: ThemeData(
        primaryColor: Color(0xFF0A74DA),
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(),
    );
  }
}
