import 'package:cursova/services/database_service.dart';
import 'package:flutter/material.dart';
import 'registration_page.dart';
import '../widgets/customAppBar.dart';
import '../widgets/drawerMenu.dart';

/// the [LoginPage] page is a page for user login
/// 
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

/// the state of the login page
/// 
/// the [emailController] is a controller for handling user email input
/// the [passwordController] is a controller for handling user password input
/// 
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      'Зареєструватися',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20
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
