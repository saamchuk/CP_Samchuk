import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:cursova/main.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/pages/updateProduct.dart';
import 'package:flutter/material.dart';

/// the [ProductTile] widget represents a product tile
/// 
/// the [id] is a path of the item
/// the [name] is a name of the item
/// the [price] is a price of the item
/// the [imageUrl] is a path to the photo of the item
/// the [description] is a description of the item
/// the [button] indicates whether to display button on the tile
/// the [update] indicates whether to update the product
/// 
class ProductTile extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
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
    required this.description,
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
                          imageUrl,
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
                            if (button)
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (MyApp.userId != '') {
                                      await FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart').doc().set({
                                        'path': id,
                                        'name': name,
                                        'photo': imageUrl,
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
        child: Container(
          width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: MediaQuery.of(context).size.height / 4,
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
                      fontSize: 20,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$price грн',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
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
                        MaterialPageRoute(builder: (context) => UpdateProduct(id: id, name: name, photo: imageUrl, price: price, description: description,))
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
        )
      ),
    );
  }
}