import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/update_category_page.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/widgets/productTile.dart';
import 'package:cursova/widgets/updateProduct.dart';
import 'package:flutter/material.dart';

class UpdateProductPage extends StatefulWidget {
  final String title;
  final String path;
  const UpdateProductPage({super.key, required this.title, required this.path});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState(title, path);

}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final String title;
  final String path;

  _UpdateProductPageState(this.title, this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateCategoryPage(title: 'Категорії', path: 'categories', categoryLocal: true)),
                );
              },
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ), 
            
            const SizedBox(height: 20),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => UpdateProduct(id: '', name: '', photo: '', price: 0))
                );
              }, 
              icon: const Icon(
                Icons.add,
                color: Colors.deepPurple,
                size: 40
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(path).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final products = snapshot.data?.docs ?? [];
                return Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20), // Відступи зліва та справа
                child: Align (
                  alignment: Alignment.center,
                  child: Wrap(// відстань між карточками по вертикалі
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      products.length,
                      (index) => ProductTile(
                        id: products[index].reference.path,
                        button: false,
                        update: true,
                        name: products[index].get('name'),
                        price: products[index].get('price'),
                        imageUrl: products[index].get('photo'),
                      ),
                    ).toList(),
                  )
                )
              );
              },
              )
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}
