import 'package:cursova/widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cursova/services/database_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Дані користувача
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Реєстрація користувача',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // поле для вводу імейла користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 8), // Додатковий відступ між текстовими полями
                  // поле для вводу пароля користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 8), // Додатковий відступ між текстовими полями
                  // поле для вводу імені користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Ім\'я користувача'),
                    ),
                  ),
                  const SizedBox(height: 8), // Додатковий відступ між текстовими полями
                  // поле для вводу номеру телефону користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Номер телефону'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]{0,10}')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25), // Додатковий відступ між текстовими полями
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Введіть ім\'я користувача!')),
                        );
                      }
                      else if (phoneNumberController.text.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Номер телефону користувача повинен складатися з 10 цифр!')),
                        );
                      }
                      else {
                        ApiService().register(emailController.text, passwordController.text, nameController.text, phoneNumberController.text, context);
                      }
                    },
                    child: const Text(
                      'Зареєструватися',
                      style: TextStyle(
                        fontSize: 20,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}
