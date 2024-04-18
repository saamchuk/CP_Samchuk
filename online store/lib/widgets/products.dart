import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/productTile.dart';
import 'package:flutter/material.dart';

/// the [Products] widget displays products based on the provided [path] 
/// 
/// the [width] is a width factor used for horizontal padding
/// the [path] is a path to the collection or current category or subcategory
/// the [all] variable indicates if it's categories
/// the [subcategories] variable indicates if it's subcategories
/// 
class Products extends StatelessWidget {
  final int width;
  final String path;
  final bool all;
  final bool subcategories;

  const Products({super.key,required this.width, required this.path, required this.subcategories, required this.all});

  @override
  Widget build(BuildContext context) {

    if (all) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(path).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final allPath = snapshot.data?.docs ?? [];

          return FutureBuilder<List<DocumentSnapshot>>(
            future: ApiService().allProducts(allPath),
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

    if (subcategories) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(path).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final allPath = snapshot.data?.docs ?? [];

          return FutureBuilder<List<DocumentSnapshot>>(
            future: ApiService().subcategoryProducts(allPath),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productSnapshot.hasError) {
                return Text('Error: ${productSnapshot.error}');
              }

              final products = productSnapshot.data ?? [];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / width), // Відступи зліва та справа
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
                        price: products[index].get('price'),
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

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(path).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final allPath = snapshot.data?.docs ?? [];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / width), // Відступи зліва та справа
          child: Align (
            alignment: Alignment.center,
            child: Wrap(// відстань між карточками по вертикалі
              alignment: WrapAlignment.center,
              children: List.generate(
                allPath.length,
                (index) => ProductTile(
                  button: true,
                  update: false,
                  id: allPath[index].reference.path,
                  name: allPath[index].get('name'),
                  price: allPath[index].get('price'),
                  imageUrl: allPath[index].get('photo'),
                  description: allPath[index].get('description'),
                ),
              ).toList(),
            )
          )
        );
      },
    );
  }
}