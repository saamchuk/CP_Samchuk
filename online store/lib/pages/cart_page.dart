import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/cartTile.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/main.dart';
import 'package:flutter/material.dart';


class CartPage extends StatefulWidget {
  static List<Map<String, dynamic>> products = [];
  const CartPage({super.key});
  
  @override
  _CartPageState createState() => _CartPageState();

}

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
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              child: ListElements(path: 'users/${MyApp.userId}/shoppingCart'),
            ),
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Загальна сума: ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                const SizedBox(width: 20),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.doc('users/${MyApp.userId}').snapshots(),
                  builder: (context, snapshot) {

                    MyApp.totalCost = 0;

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      // Якщо немає даних або вони нульові, відобразіть заглушку або недоступність
                      return const SizedBox(height: 5);
                    }

                    final user = snapshot.data!.data() as Map<String, dynamic>;
                    MyApp.totalCost = user['totalCost'];

                    return Text(
                      '${MyApp.totalCost} грн',
                      style: const TextStyle(
                        fontSize: 25,
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

                MyApp.totalCost = 0;

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  // Якщо немає даних або вони нульові, відобразіть заглушку або недоступність
                  return const SizedBox(height: 5);
                }

                final user = snapshot.data!.data() as Map<String, dynamic>;
                MyApp.totalCost = user['totalCost'];

                if (MyApp.totalCost == 0) {
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
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Адреса доставки'),
                      ),
                    ),
                    const SizedBox(height: 25), // Додатковий відступ між текстовими полями
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

class ListElements extends StatelessWidget{
  final String path;

  const ListElements({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final allProducts = snapshot.data?.docs ?? [];

        MyApp.totalCost = 0;

        CartPage.products = [];

        if (allProducts != []) {
          for (var product in allProducts) {
            var productData = product.data() as Map<String, dynamic>;
            MyApp.totalCost += productData['price'];

            CartPage.products.add({
              'path': productData['path'],
              'name': productData['name'],
              'price': productData['price'],
              'photo': productData['photo']
            });
          }
        }

        ApiService().updateTotalCost();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: allProducts.length,
          itemBuilder: (context, index) {
            final product = allProducts[index];
            final productData = product.data() as Map<String, dynamic>;

            return CartTile(
              path: product.reference.path,
              name: productData['name'],
              price: productData['price'],
              photo: productData['photo'],
            );
          }
        );
      },
    );
  }
}