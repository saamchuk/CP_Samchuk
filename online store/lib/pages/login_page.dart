import 'package:cursova/services/database_service.dart';
import 'package:flutter/material.dart';
import 'registration_page.dart';
import '../widgets/customAppBar.dart';
import '../widgets/drawerMenu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    'Вхід користувача',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8), // Додатковий відступ між текстовими полями
                  // ввід імейла користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 8), // Додатковий відступ між текстовими полями
                  // ввід пароля користувача
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () async {
                      await ApiService().login(emailController.text, passwordController.text, context);
                    },
                    child: const Text(
                      'Ввійти',
                      style: TextStyle(
                        fontSize: 20,
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      'Зареєструватися',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ]
        ) 
      ),
      drawer: const DrawerMenu(),
    );
  }
}
