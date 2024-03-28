import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/widgets/products.dart';
import 'package:flutter/material.dart';

class SubCategoriesPage extends StatefulWidget {
  const SubCategoriesPage({super.key});

  @override
  _SubCategoriesPageState createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  String path = 'categories'; //шлях до колекції чи поточної категорії чи підкатегорії
  String category = 'categories'; // шлях до колекції чи поточної категорії
  bool all = true; // чи це категорії
  bool subcategories = true; // чи це підкатегорії
  String nameCategory = "Категорії"; // заголовок для списку категорій
  String nameProducts = "Товари";
  
  _SubCategoriesPageState();

  void _updatePath(String newPath) {
    setState(() {
      path = newPath;
      if (all) {
        all = false;
      }
      else {
        subcategories = false;
      }
    });
  }

  void _updateName(String newName) {
    setState(() {
      if (subcategories) {
        nameCategory = newName;
      }
      else {
        nameProducts = newName;
      }
    });
  }

  void _updateCategory(String newCategory) {
    setState(() {
      category = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ 
            ListProduct(path: path, onUpdatePath: _updatePath, subcategories: subcategories, category: category, all: all, onUpdateName: _updateName, nameCategory: nameCategory, onUpdateCategory: _updateCategory, nameProducts: nameProducts),
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}

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
                          fontSize: 25,
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
                        fontSize: 25,
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