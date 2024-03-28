import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/main.dart';
import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final String path;
  final String name;
  final double price;
  final String photo;

  const CartTile({
    required this.name,
    required this.price,
    super.key, 
    required this.path, 
    required this.photo
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Ліва половина - фото товару
                    Expanded(
                      flex: 1,
                      child: Container(
                        //height: MediaQuery.of(context).size.width, // висота фото
                        alignment: Alignment.center,
                        child: Image.network(
                          photo,
                          height: MediaQuery.of(context).size.height / 2,
                          fit: BoxFit.cover, // зміст фото
                        ),
                      ),
                    ),
                  // Права половина - інформація про товар
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          // Назва товару
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Ціна товару
                            Text(
                              'Ціна: $price грн',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Опис товару
                            const Text(
                              'Опис товару:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Кнопка "Купити"
                            ElevatedButton(
                              onPressed: () async {
                                if (MyApp.userId != '') {
                                  await FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').doc().set({
                                    'path': path,
                                    'name': name,
                                    'photo': photo,
                                    'price': price,
                                  });

                                  Navigator.of(context).pop();
                                  
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                }
                              },
                              child: const Text('Додати в кошик'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(10),
        child: SizedBox(
          height: 125,
          width: MediaQuery.of(context).size.width / 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Expanded (
                child: Image.network(
                  photo,
                )
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis, // Перенос тексту з міткою
                        softWrap: true, // Включення переносу тексту
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        '$price грн',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 15,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        alignment: Alignment.center,
                        onPressed: () async {
                          await FirebaseFirestore.instance.doc(path).delete();
                          
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}