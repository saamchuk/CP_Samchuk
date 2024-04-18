import 'package:cursova/main.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cursova/services/database_service.dart';

/// the registration page of the application
/// 
/// the [RegistrationPage] page allows the user to create a new account
/// 
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _RegistrationPageState();
}

/// the state of the registration page
/// 
/// the [emailController] is a controller for handling user email input
/// the [passwordController] is a controller for handling user password input
/// the [nameController] is a controller for handling user name input
/// the [phoneNumberController] is a controller for handling user phone number input
/// 
class _RegistrationPageState extends State<RegistrationPage> {

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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Ім\'я користувача'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Номер телефону'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]{0,10}')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
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
                        setState(() {
                          MyApp.access = MyApp.access;
                          MyApp.userId = MyApp.userId;
                        });
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
