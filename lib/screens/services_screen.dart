import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';

class ServicesScreen extends StatelessWidget {
  final List<CardModel> cards;
  final Function(TransactionModel) onTransactionAdded;
  final Function(String, double) updateBalance;

  ServicesScreen({
    required this.cards,
    required this.onTransactionAdded,
    required this.updateBalance,
  });

  final List<ServiceModel> services = [
    ServiceModel(name: 'Коммунальные услуги', icon: Icons.home),
    ServiceModel(name: 'Мобильная связь', icon: Icons.phone),
    ServiceModel(name: 'Интернет', icon: Icons.wifi),
  ];

  void _payForService(BuildContext context, ServiceModel service) {
    CardModel? selectedCard;
    double amount = 0.0;
    String additionalField = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Оплата: ${service.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<CardModel>(
              hint: Text("Выберите карту"),
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
              decoration: InputDecoration(labelText: "Сумма"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
              },
            ),
            if (service.name == "Мобильная связь" || service.name == "Интернет")
              TextField(
                decoration: InputDecoration(
                    labelText: service.name == "Мобильная связь"
                        ? "Номер телефона"
                        : "Номер счета"),
                onChanged: (value) {
                  additionalField = value;
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedCard != null && amount > 0) {
                if (selectedCard!.balance >= amount) {
                  updateBalance(selectedCard!.cardNumber, -amount);
                  onTransactionAdded(TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    cardNumber: selectedCard!.cardNumber,
                    amount: -amount,
                    type: service.name,
                    date: DateTime.now(),
                  ));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Недостаточно средств на карте!")),
                  );
                }
              }
            },
            child: Text("Оплатить"),
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
      appBar: AppBar(title: Text('Оплата услуг')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () => _payForService(context, service),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(service.icon, size: 48.0),
                  SizedBox(height: 10.0),
                  Text(service.name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
