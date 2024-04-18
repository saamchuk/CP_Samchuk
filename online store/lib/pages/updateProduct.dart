import 'dart:html' as html;
import 'dart:io';

import 'package:cursova/services/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

/// the [UpdateProduct] page allows the admin user to update product details
/// 
/// the [id] is a path of the item
/// the [name] is a name of the item
/// the [price] is a price of the item
/// the [photo] is a path to the photo of the item
/// the [description] is a description of the item
/// 
class UpdateProduct extends StatefulWidget {
  final String id;
  final String name;
  final String photo;
  final double price;
  final String description;
  const UpdateProduct({super.key, required this.id, required this.name, required this.photo, required this.price, required this.description});
  
  @override
  State<StatefulWidget> createState() => _UpdateProductState();
}

/// the state of the update product page
/// 
/// the [path] is a path of the uploaded image
class _UpdateProductState extends State<UpdateProduct> {
  String path = '';

  /// the [_updatePath] function updates the [path]
  /// 
  /// the [newPath] is a new path of the uploaded image
  /// 
  void _updatePath(String newPath) {
    setState(() {
      path = newPath;
    });
  }

  _UpdateProductState();

  /// the [uploadImage] function uploads an image
  /// 
  Future<void> uploadImage(BuildContext context) async {
    if (UniversalPlatform.isWindows) {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
  if (result != null) {
    final filePath = result.files.single.path!;
    final file = File(filePath);

    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    await storageRef.putFile(file);

    final imageUrl = await storageRef.getDownloadURL();

    if (path.isNotEmpty) {
      ApiService().deleteImage(path);
    }

    _updatePath(imageUrl);
  }
    } 
    else {
     final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;

    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    await storageRef.putBlob(html.Blob([file]), SettableMetadata(contentType: 'image/jpeg'));

    final imageUrl = await storageRef.getDownloadURL();

    if (path.isNotEmpty) ApiService().deleteImage(path);

    _updatePath(imageUrl);
    }  
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: widget.name);
    final TextEditingController priceController = TextEditingController(text: widget.price.toString());
    final TextEditingController descriptionController = TextEditingController(text: widget.description);
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
                  if(widget.photo.isNotEmpty && path.isEmpty)
                  Image.network(
                    widget.photo,
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
                      style: TextStyle(
                        fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Назва товару'),
                    ),
                  ),
                  const SizedBox(height: 20), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20
                      ),
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
                      style: const TextStyle(
                        fontSize: 20
                      ),
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Опис товару'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()  {
                      if(widget.photo.isEmpty && path.isEmpty) {
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
                      else if (path.isNotEmpty && widget.photo.isNotEmpty) {
                        ApiService().updateProduct(widget.id, path, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                      else if (path.isEmpty && widget.photo.isNotEmpty){
                        ApiService().updateProduct(widget.id, widget.photo, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                      else if(path.isNotEmpty && widget.photo.isEmpty) {
                        ApiService().addNewProduct(widget.id, path, nameController.text, double.parse(priceController.text), descriptionController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Зберегти дані',
                      style: TextStyle(
                        fontSize: 20
                      ),
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