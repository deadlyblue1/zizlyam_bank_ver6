import 'package:flutter/material.dart';
import 'cards_screen.dart';
import 'services_screen.dart';
import 'account_screen.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';
import 'login_screen.dart';

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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<CardModel> cards = [
    CardModel(cardNumber: '**** **** **** 1234', balance: 5000.00),
    CardModel(cardNumber: '**** **** **** 5678', balance: 3000.00),
  ];

  List<TransactionModel> transactions = [];

  void _onTransactionAdded(TransactionModel transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  void _updateCardBalance(String cardNumber, double amount) {
    setState(() {
      final card = cards.firstWhere((c) => c.cardNumber == cardNumber);
      card.balance += amount;
    });
  }

  void _onLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      CardsScreen(
        cards: cards,
        onTransactionAdded: _onTransactionAdded,
        onLogout: _onLogout,
        updateBalance: _updateCardBalance,
      ),
      ServicesScreen(
        cards: cards,
        onTransactionAdded: _onTransactionAdded,
        updateBalance: _updateCardBalance,
      ),
      AccountScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Карты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Услуги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',
          ),
        ],
      ),
    );
  }
}
