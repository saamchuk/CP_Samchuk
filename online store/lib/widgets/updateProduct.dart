import 'dart:html' as html;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


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

  void _updatePath(String newPath) {
    setState(() {
      photo = newPath;
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

    _updatePath(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
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
                  if(photo.isNotEmpty)
                  Image.network(
                    photo,
                    height: MediaQuery.of(context).size.height / 4),
                  ElevatedButton(
                    onPressed: ()  {
                      uploadImage(context);                      
                    },
                    child: const Text(
                      'Завантажити зображення',
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