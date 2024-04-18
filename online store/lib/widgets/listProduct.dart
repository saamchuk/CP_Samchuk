import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/categories_page.dart';
import 'package:cursova/widgets/products.dart';
import 'package:flutter/material.dart';

/// the [ListProduct] widget displays a list of subcategories and products
/// 
/// the [path] is a path to the collection or current category or subcategory
/// the [category] is a path to the collection or current category
/// the [all] variable indicates if it's categories
/// the [subcategories] variable indicates if it's subcategories
/// the [nameCategory] is a title for the category list
/// the [nameProducts] is a title for the products
/// 
/// the [onUpdatePath] function is a function for update [path]
/// the [onUpdateName] function is a function for update [nameCategory] and [nameProducts]
/// the [onUpdateCategory] function is a function for update [category]
/// 
class ListProduct extends StatelessWidget {

  final String path;
  final String category;
  final bool subcategories;
  final bool all;
  final String nameCategory;
  final String nameProducts;
  final Function(String) onUpdatePath;
  final Function(String) onUpdateName;
  final Function(String) onUpdateCategory;

  const ListProduct({super.key, required this.path, required this.subcategories, required this.onUpdatePath, required this.category, required this.all, required this.onUpdateName, required this.nameCategory, required this.onUpdateCategory, required this.nameProducts});
  
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(category).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final categories = snapshot.data?.docs ?? [];

        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SubCategoriesPage()),
                        );
                      },
                      child: Text(
                        nameCategory,
                        style: const TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.italic
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ), 
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final categoryData = category.data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(
                            categoryData['name'],
                            style: const TextStyle(
                              fontSize: 20
                            )
                          ),
                          onTap: () async {
                            if (all) {
                              onUpdatePath("${category.reference.path}/subcategories");
                              onUpdateCategory("${category.reference.path}/subcategories");
                              onUpdateName(categoryData['name']);
                            } 
                            else {
                              onUpdatePath("${category.reference.path}/products");
                              onUpdateName(categoryData['name']);
                            }
                          },
                        );
                      },
                    ),
                  ]
                )
              ),
              const SizedBox(width: 20),
              Flexible(
                flex: 7,
                child: Column(
                  children: [ 
                    const SizedBox(height: 20),
                    Text(
                      nameProducts,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 20),
                    Products(width: 20, path: path, subcategories: subcategories, all: all),
                  ]
                )
              )
            ],
          ),
        );
      },
    );
  }
}