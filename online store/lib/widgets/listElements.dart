import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/main.dart';
import 'package:cursova/pages/cart_page.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/cartTile.dart';
import 'package:flutter/material.dart';

/// the [ListElements] widget representing the list of elements in the shopping cart
/// 
class ListElements extends StatelessWidget{

  const ListElements({super.key});

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

        double totalCost = 0;

        CartPage.products = [];

        if (allProducts != []) {
          for (var product in allProducts) {
            var productData = product.data() as Map<String, dynamic>;
            totalCost += productData['price'];

            CartPage.products.add({
              'path': productData['path'],
              'name': productData['name'],
              'price': productData['price'],
              'photo': productData['photo'],
              'description': productData['description']
            });
          }
        }

        ApiService().updateTotalCost(totalCost);

        return ListView.builder(
          shrinkWrap: true,
          itemCount: allProducts.length,
          itemBuilder: (context, index) {
            final product = allProducts[index];
            final productData = product.data() as Map<String, dynamic>;

            return CartTile(
              path: product.reference.path,
              name: productData['name'],
              price: productData['price'].toDouble(),
              photo: productData['photo'],
              description: productData['description'],
            );
          }
        );
      },
    );
  }
}