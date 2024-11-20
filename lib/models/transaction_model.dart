// models/transaction_model.dart
class TransactionModel {
  final int id;
  final String cardNumber;
  final double amount;
  final String type; // 'income' или 'expense'
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.cardNumber,
    required this.amount,
    required this.type,
    required this.date,
  });
}
