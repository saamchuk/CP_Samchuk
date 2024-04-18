import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/home_page.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/main.dart';
import 'package:cursova/widgets/listElements.dart';
import 'package:flutter/material.dart';

/// the shopping cart page of the application
/// 
/// the [CartPage] page displays the shopping cart of the current user, 
/// which includes the list of products added to the cart, the total cost,
/// and allows the user to confirm the order by providing the delivery address
/// 
/// the [products] is a list of products added to the cart of the current user
/// 
class CartPage extends StatefulWidget {

  static List<Map<String, dynamic>> products = [];
  const CartPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _CartPageState();

}

/// the state of the shopping cart page
/// 
/// the [addressController] is a controller for handling the user's input for the delivery address
/// 
class _CartPageState extends State<CartPage> {

  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Кошик',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              child: const ListElements(),
            ),
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Загальна сума: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                const SizedBox(width: 20),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.doc('users/${MyApp.userId}').snapshots(),
                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox(height: 5);
                    }

                    final user = snapshot.data!.data() as Map<String, dynamic>;
                    double totalCost = user['totalCost'];

                    return Text(
                      '$totalCost грн',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      )
                    );
                  }
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.doc('users/${MyApp.userId}').snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(height: 5);
                }

                final user = snapshot.data!.data() as Map<String, dynamic>;
                double totalCost = user['totalCost'];

                if (totalCost == 0) {
                  return const Text(
                    '(Ваш кошик порожній!)',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 20
                        ),
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Адреса доставки'),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () async {
                        if (addressController.text != '') {

                          ApiService().confirm(addressController.text);
                      
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const HomePage())
                          ); 
                        }
                      },
                      child: const Text(
                        'Оформити замовлення',
                        style: TextStyle(
                          fontSize: 20,
                        )
                      ),
                    ),
                    const SizedBox(height: 20)
                  ]
                );
              }
            ),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
    );
  }
}