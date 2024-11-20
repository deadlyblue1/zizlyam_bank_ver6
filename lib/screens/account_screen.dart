import 'package:flutter/material.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = 'Иван Иванов';
  String phone = '+7 900 123 45 67';
  String email = 'ivan.ivanov@example.com';

  void _editAccountDetails(BuildContext context) {
    String updatedName = name;
    String updatedPhone = phone;
    String updatedEmail = email;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Изменить данные'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Имя'),
                controller: TextEditingController(text: name),
                onChanged: (value) => updatedName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Телефон'),
                keyboardType: TextInputType.phone,
                controller: TextEditingController(text: phone),
                onChanged: (value) => updatedPhone = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                controller: TextEditingController(text: email),
                onChanged: (value) => updatedEmail = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                name = updatedName;
                phone = updatedPhone;
                email = updatedEmail;
              });
              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Аккаунт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Имя', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(name, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  Text('Телефон',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(phone, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(email, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _editAccountDetails(context),
              icon: Icon(Icons.edit),
              label: Text('Изменить данные'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout),
              label: Text("Выйти из аккаунта"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
