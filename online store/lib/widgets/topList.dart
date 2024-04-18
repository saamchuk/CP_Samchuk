import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/widgets/productTile.dart';
import 'package:flutter/material.dart';

/// the [TopList] widget displays the top list of products retrieved from Firestore
/// 
/// the [width] is used to control the horizontal padding around the product tiles
/// 
class TopList extends StatelessWidget {
  final int width;

  const TopList({super.key,required this.width});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('top').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final allPath = snapshot.data?.docs ?? [];

        return FutureBuilder<List<DocumentSnapshot>>(
          future: _getProducts(allPath),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (productSnapshot.hasError) {
              return Text('Error: ${productSnapshot.error}');
            }

            final products = productSnapshot.data ?? [];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / width),
              child: Align (
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    products.length,
                    (index) => ProductTile(
                      button: true,
                      update: false,
                      id: products[index].reference.path,
                      name: products[index].get('name'),
                      price: products[index].get('price').toDouble(),
                      imageUrl: products[index].get('photo'),
                      description: products[index].get('description'),
                    ),
                  ).toList(),
                )
              )
            );
          },
        );
      },
    );
  }
}

/// function to fetch products using their paths
/// 
/// the [_getProducts] function retrieves product documents from Firestore based on the provided [productPaths]
/// the [productPaths] is a list of [QueryDocumentSnapshot] objects representing the paths to the products
/// the [_getProducts] function returns a [Future] that completes wirt a list of [DocumentSnapshot] objects representing the products
/// 
Future<List<DocumentSnapshot>> _getProducts(List<QueryDocumentSnapshot> productPaths) async {
  List<DocumentSnapshot> products = [];
  for (QueryDocumentSnapshot productPath in productPaths) {
    DocumentSnapshot product = await FirebaseFirestore.instance.doc(productPath['path']).get();
    if (product.exists) products.add(product);
  }
  return products;
}
