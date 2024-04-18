import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/update_category_page.dart';
import 'package:cursova/pages/update_product_page.dart';
import 'package:flutter/material.dart';

/// the [CategoryTile] widget represents category
/// 
/// the [data] is a data of the category 
/// the [id] is a unique identifier of the category
/// the [category] indicates whether it's a category or not (a subcategory)
/// 
class CategoryTile extends StatelessWidget{
  final Map<String, dynamic> data;
  final String id;
  final bool category;

  const CategoryTile({required this.data, super.key, required this.id, required this.category});

  @override
  Widget build (BuildContext context) {
    TextEditingController nameController = TextEditingController(text: data['name']);
    return Center (
      child: Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              Expanded(
                child: Text(
                  '${data['name']}',
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
              ),
              const SizedBox(width: 30)
            ],
          ),
                            
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: ()  {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Редагування категорії",
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
                                  FirebaseFirestore.instance.doc(id).update({'name': nameController.text});
                                  Navigator.of(context).pop();
                                }
                                if (nameController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Введіть ім\'я категорії!')),
                                  );
                                  nameController = TextEditingController(text: data['name']);
                                }
                              },
                              child: const Text(
                                "Зберегти зміни",
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
                  child: const Icon(Icons.edit)
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (category) {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => UpdateCategoryPage(title: data['name'], path: '${id}/subcategories', categoryLocal: false))
                      );
                    }
                    else {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => UpdateProductPage(title: data['name'], path: '${id}/products'))
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward)
                )
              ]
            )
          ),
        ),
      )
    );
  }
}