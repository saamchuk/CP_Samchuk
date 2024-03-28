import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/main.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/updateProduct.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool button;
  final bool update;

  const ProductTile({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    super.key, 
    required this.button, 
    required this.update,
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
                        //height: MediaQuery.of(context).size.height / 10 , // висота фото
                        alignment: Alignment.center,
                        child: Image.network(
                          imageUrl,
                          //height: MediaQuery.of(context).size.height / 2,
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
                            if (button)
                            ElevatedButton(
                              onPressed: () async {
                                if (MyApp.userId != '') {
                                  await FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').doc().set({
                                    'path': id,
                                    'name': name,
                                    'photo': imageUrl,
                                    'price': price,
                                  });
                                  // Отримання посилання на колекцію користувачів
                                  CollectionReference users = FirebaseFirestore.instance.collection('users');

                                  // Отримання поточного значення totalCost
                                  DocumentSnapshot userDoc = await users.doc(MyApp.userId).get();
                                  double currentTotalCost = userDoc['totalCost'];

                                  // Збільшення totalCost на 1
                                  MyApp.totalCost = currentTotalCost + price;

                                  // Оновлення totalCost у базі даних
                                  await users.doc(MyApp.userId).update({'totalCost': MyApp.totalCost});
                                  
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: MediaQuery.of(context).size.height / 4,
              //fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ціна: $price грн',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  if(button && !update)
                  ElevatedButton(
                    onPressed: () async {
                      if (MyApp.userId != '') {
                        await FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').doc().set({
                          'path': id,
                          'name': name,
                          'photo': imageUrl,
                          'price': price,
                        });

                        // Отримання посилання на колекцію користувачів
                        CollectionReference users = FirebaseFirestore.instance.collection('users');

                        // Отримання поточного значення totalCost
                        DocumentSnapshot userDoc = await users.doc(MyApp.userId).get();
                        double currentTotalCost = userDoc['totalCost'];

                        // Збільшення totalCost на 1
                        MyApp.totalCost = currentTotalCost + price;

                        // Оновлення totalCost у базі даних
                        await users.doc(MyApp.userId).update({'totalCost': MyApp.totalCost});

                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      }
                    },
                    child: const Text('Додати в кошик'),
                  ),
                  if (update && !button) 
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProduct(id: id, name: name, photo: imageUrl, price: price))
                      );
                    }, 
                    child: const Icon(Icons.edit)
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      ApiService().deleteElement(id);
                    }, 
                    child: const Icon(Icons.delete)
                  )
                    ],
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}