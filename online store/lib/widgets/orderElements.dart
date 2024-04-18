import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/widgets/productTile.dart';
import 'package:flutter/material.dart';

/// the [OrderElements] widget displays order elements
/// 
/// the [path] is a path to the collection of order elements
/// the [button] indicates whether buttons should be displayed
/// the [width] is a width of the widget
///  
class OrderElements extends StatelessWidget{
  final String path;
  final bool button;
  final int width;

  const OrderElements({super.key, required this.path, required this.button, required this.width});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(path).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final allProducts = snapshot.data?.docs ?? [];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / width), // Відступи зліва та справа
          child: Align (
            alignment: Alignment.center,
            child: Wrap(// відстань між карточками по вертикалі
              alignment: WrapAlignment.center,
              children: List.generate(
                allProducts.length,
                (index) => ProductTile(
                  button: button,
                  update: false,
                  id: allProducts[index].reference.path,
                  name: allProducts[index].get('name'),
                  price: allProducts[index].get('price').toDouble(),
                  imageUrl: allProducts[index].get('photo'),
                  description: allProducts[index].get('description'),
                ),
              ).toList(),
            )
          )
        );
      },
    );
  }
}
