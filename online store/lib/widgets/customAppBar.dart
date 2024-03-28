import 'package:cursova/pages/cart_page.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/main.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade200,
      title: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: const Text('SAAMCHUK'),
      ), 
      toolbarHeight: 70,
      leading:
        Builder( 
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); 
            },
          ),
        ),
      actions: [
        if ( MyApp.userId != '')
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        const SizedBox(width: 10),
        IconButton(
          icon: MyApp.userId != '' ? const Icon(Icons.logout) : const Icon(Icons.account_circle),
          onPressed: () {
            if (MyApp.userId != '') {
              MyApp.userId = '';
              MyApp.access = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}