import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';
import 'transactions_screen.dart';

class CardsScreen extends StatelessWidget {
  final List<CardModel> cards;
  final Function(TransactionModel) onTransactionAdded;
  final Function(String, double) updateBalance; // Добавлено
  final Function onLogout;

  CardsScreen({
    required this.cards,
    required this.onTransactionAdded,
    required this.updateBalance, // Добавлено
    required this.onLogout,
  });

  void _showAddCardForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Заказать новую карту"),
        content: Text("Новая карта будет добавлена с нулевым балансом."),
        actions: [
          TextButton(
            onPressed: () {
              // Логика добавления новой карты
            },
            child: Text("Подтвердить"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена"),
          ),
        ],
      ),
    );
  }

  void _showTransactions(BuildContext context, int cardIndex) {
    final selectedCard = cards[cardIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionsScreen(
          card: selectedCard,
          transactions: [], // Предположим, что это все транзакции для этой карты
        ),
      ),
    );
  }

  void _showTransferDialog(BuildContext context) {
    CardModel? fromCard;
    CardModel? toCard;
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Перевод средств"),
        content: Column(
          children: [
            DropdownButton<CardModel>(
              hint: Text("Выберите карту для перевода"),
              value: fromCard,
              onChanged: (CardModel? newCard) {
                fromCard = newCard;
              },
              items: cards.map((CardModel card) {
                return DropdownMenuItem<CardModel>(
                  value: card,
                  child: Text(card.cardNumber),
                );
              }).toList(),
            ),
            DropdownButton<CardModel>(
              hint: Text("Выберите карту получателя"),
              value: toCard,
              onChanged: (CardModel? newCard) {
                toCard = newCard;
              },
              items: cards.map((CardModel card) {
                return DropdownMenuItem<CardModel>(
                  value: card,
                  child: Text(card.cardNumber),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Введите сумму'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (fromCard != null && toCard != null && amount > 0) {
                if (fromCard!.balance >= amount) {
                  // Обновляем балансы через updateBalance
                  updateBalance(fromCard!.cardNumber, -amount);
                  updateBalance(toCard!.cardNumber, amount);

                  // Создаем транзакции
                  onTransactionAdded(TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    cardNumber: fromCard!.cardNumber,
                    amount: -amount,
                    type: 'transfer',
                    date: DateTime.now(),
                  ));
                  onTransactionAdded(TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch + 1,
                    cardNumber: toCard!.cardNumber,
                    amount: amount,
                    type: 'transfer',
                    date: DateTime.now(),
                  ));
                  Navigator.pop(context);
                } else {
                  // Показываем ошибку, если на карте недостаточно средств
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Недостаточно средств на карте для перевода")),
                  );
                }
              }
            },
            child: Text("Подтвердить"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена"),
          ),
        ],
      ),
    );
  }

  void _showTopUpDialog(BuildContext context) {
    CardModel? selectedCard;
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Пополнение баланса"),
        content: Column(
          children: [
            DropdownButton<CardModel>(
              hint: Text("Выберите карту для пополнения"),
              value: selectedCard,
              onChanged: (CardModel? newCard) {
                selectedCard = newCard;
              },
              items: cards.map((CardModel card) {
                return DropdownMenuItem<CardModel>(
                  value: card,
                  child: Text(card.cardNumber),
                );
              }).toList(),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Введите сумму пополнения'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedCard != null && amount > 0) {
                // Пополняем баланс карты через updateBalance
                updateBalance(selectedCard!.cardNumber, amount);

                onTransactionAdded(TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  cardNumber: selectedCard!.cardNumber,
                  amount: amount,
                  type: 'top-up',
                  date: DateTime.now(),
                ));
                Navigator.pop(context);
              }
            },
            child: Text("Подтвердить"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваши карты'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => onLogout(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Кнопки для перевода и пополнения
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _showTopUpDialog(context),
                child: Text('Пополнить баланс'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Изменено с primary на backgroundColor
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _showTransferDialog(context),
                child: Text('Перевести средства'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Изменено с primary на backgroundColor
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: ListTile(
                    title: Text('Карта: ${card.cardNumber}'),
                    subtitle:
                        Text('Баланс: \$${card.balance.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Логика удаления карты
                      },
                    ),
                    onTap: () => _showTransactions(context, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCardForm(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF0A74DA),
      ),
    );
  }
}
