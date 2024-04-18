import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/main.dart';
import 'package:flutter/material.dart';

/// the [CartTile] widget displays a single item in the cart
/// 
/// the [path] is a path of the item
/// the [name] is a name of the item
/// the [price] is a price of the item
/// the [photo] is a path to the photo of the item
/// the [description] is a description of the item
/// 
class CartTile extends StatelessWidget {
  final String path;
  final String name;
  final double price;
  final String photo;
  final String description;

  const CartTile({
    required this.name,
    required this.price,
    super.key, 
    required this.path, 
    required this.photo, 
    required this.description
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
                    // left half - item photo
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.network(
                          photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // right half - item information
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                            children: [ 
                              const Text(
                                'Ціна: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' $price грн',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8),
                            const Text(
                              'Опис товару:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (MyApp.userId != '') {
                                      await FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').doc().set({
                                        'path': path,
                                        'name': name,
                                        'photo': photo,
                                        'price': price,
                                        'description': description
                                      });

                                      // get the reference to the users collection
                                      CollectionReference users = FirebaseFirestore.instance.collection('users');

                                      // get the current value of total cost
                                      DocumentSnapshot userDoc = await users.doc(MyApp.userId).get();
                                      double currentTotalCost = userDoc['totalCost'];

                                      /// increase [totalCost] by the price of the item
                                      double totalCost = currentTotalCost + price;

                                      // update total cost in the database
                                      await users.doc(MyApp.userId).update({'totalCost': totalCost});

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
                              ),
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