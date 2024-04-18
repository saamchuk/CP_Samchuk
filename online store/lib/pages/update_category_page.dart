import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/widgets/categoryTile.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:flutter/material.dart';

/// the category update page of the application
/// 
/// the [UpdateCategoryPage] page allows the admin user to update categories
/// 
/// the [title] is a title of the page
/// the [path] is a path to the collection in the Firestore database
/// the [categoryLocal] indicates whether it's a category or not (a subcategory)
/// 
class UpdateCategoryPage extends StatelessWidget {
  final String title;
  final String path;
  final bool categoryLocal;
  const UpdateCategoryPage({super.key, required this.title, required this.path, required this.categoryLocal});

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateCategoryPage(title: 'Категорії', path: 'categories', categoryLocal: true)),
                );
              },
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ), 
            
            const SizedBox(height: 20),

            IconButton(
              onPressed: () {
                TextEditingController nameController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Нова категорія",
                        style: TextStyle(
                          fontSize: 30
                        ),
                        textAlign: TextAlign.center
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Назва категорії'),
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty) {
                              FirebaseFirestore.instance.collection(path).doc().set({
                                'name': nameController.text,
                              });
                              Navigator.of(context).pop();
                            }
                            if (nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Введіть ім\'я категорії!')),
                              );
                            }
                          },
                          child: const Text(
                            "Створити категорію",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ),
                      ],
                    );
                  }
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

                final categories = snapshot.data?.docs ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final String categoryId = category.reference.path;
                    final categoryData = category.data() as Map<String, dynamic>;

                    return CategoryTile(data: categoryData, id: categoryId, category: categoryLocal);
                  },
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
