import 'package:cursova/pages/account_page.dart';
import 'package:cursova/pages/cart_page.dart';
import 'package:cursova/main.dart';
import 'package:cursova/pages/combination_main_page.dart';
import 'package:cursova/pages/home_page.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/pages/order_page.dart';
import 'package:cursova/pages/categories_page.dart';
import 'package:cursova/pages/update_category_page.dart';
import 'package:flutter/material.dart';

/// the [DrawerMenu] widget is used for navigation
/// 
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            constraints: const BoxConstraints.tightFor(height: 75), 
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
              ),
              child: const Text(
                'Меню',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Категорії',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubCategoriesPage()),
              );
            },
          ),
          if (MyApp.userId.isNotEmpty)
            ListTile(
              title: const Text(
                'Кошик',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
          if (MyApp.userId.isNotEmpty)
          ListTile(
            title: const Text(
              'Замовлення',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersPage()),
                );
              // Додайте код для відкриття сторінки "Мої замовлення"
            },
          ),
          if (MyApp.userId.isNotEmpty)
          ListTile(
            title: const Text(
              'Поєднання',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CombinationMainPage()),
                );
              // Додайте код для відкриття сторінки "Мої замовлення"
            },
          ),
          if (MyApp.access && MyApp.userId.isNotEmpty)
          ListTile(
            title: const Text(
              'Внести зміни',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateCategoryPage(title: 'Категорії', path: 'categories', categoryLocal: true)),
                );
              // Додайте код для відкриття сторінки "Мої замовлення"
            },
          ),
          if (MyApp.userId.isNotEmpty)
          ListTile(
            title: const Text(
              'Акаунт',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          if (MyApp.userId.isEmpty)
          ListTile(
            title: const Text(
              'Вхід',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          if (MyApp.userId.isNotEmpty)
          ListTile(
            title: const Text(
              'Вихід',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            onTap: () {
              MyApp.userId = '';
              MyApp.access = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}