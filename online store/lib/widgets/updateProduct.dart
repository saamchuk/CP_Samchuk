import 'dart:html' as html;

import 'package:cursova/services/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UpdateProduct extends StatefulWidget {
  final String id;
  final String name;
  final String photo;
  final double price;
  const UpdateProduct({super.key, required this.id, required this.name, required this.photo, required this.price});

  @override
  _UpdateProductState createState() => _UpdateProductState(id, name, photo, price);

}

class _UpdateProductState extends State<UpdateProduct> {
  final String id;
  final String name;
  String photo;
  final double price;
  String path = '';

  void _updatePath(String newPath) {
    setState(() {
      path = newPath;
    });
  }

  _UpdateProductState(this.id, this.name, this.photo, this.price);

  Future<void> uploadImage(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;

    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    // Завантаження файлу в Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    await storageRef.putBlob(html.Blob([file]), SettableMetadata(contentType: 'image/jpeg'));

    // Отримання URL завантаженого зображення
    final imageUrl = await storageRef.getDownloadURL();

    if (path.isNotEmpty) ApiService().deleteImage(path);

    _updatePath(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController priceController = TextEditingController(text: price.toString());
    final TextEditingController descriptionController = TextEditingController(text: name);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі товару'),
        backgroundColor: Colors.blue.shade200,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if(photo.isNotEmpty && path.isEmpty)
                  Image.network(
                    photo,
                    height: 400
                  ),
                  if (path.isNotEmpty)
                  Image.network(
                    path,
                    height: MediaQuery.of(context).size.height / 4
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()  {
                      uploadImage(context);                      
                    },
                    child: const Text(
                      'Завантажити зображення',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Назва товару'),
                    ),
                  ),
                  const SizedBox(height: 20), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Ціна товару (грн)'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Опис товару'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()  {
                      if(photo.isEmpty && path.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Завантажте зображення!')),
                        );
                      }
                      else if(nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Введіть назву товару!')),
                        );
                      }
                      else if(priceController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Введіть ціну товару!')),
                        );
                      }
                      else if(descriptionController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Введіть опис товару!')),
                        );
                      }
                      else if (path.isNotEmpty && photo.isNotEmpty) {
                        ApiService().updateProduct(id, path, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                      else if (path.isEmpty && photo.isNotEmpty){
                        ApiService().updateProduct(id, photo, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                      else if(path.isNotEmpty && photo.isEmpty) {
                        ApiService().addNewProduct(id, path, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Зберегти дані',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              )
            )
          ]
        )
      )
    );
  }
}