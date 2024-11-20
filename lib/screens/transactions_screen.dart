import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';

class TransactionsScreen extends StatelessWidget {
  final CardModel card;
  final List<TransactionModel> transactions;

  TransactionsScreen({required this.card, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Транзакции для ${card.cardNumber}')),
      body: transactions.isEmpty
          ? Center(child: Text('Нет транзакций для этой карты.'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction.type == 'expense'
                      ? 'Списание: \$${transaction.amount}'
                      : 'Пополнение: \$${transaction.amount}'),
                  subtitle: Text(transaction.date.toString()),
                );
              },
            ),
    );
  }
}
