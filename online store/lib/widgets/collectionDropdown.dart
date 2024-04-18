import 'package:cursova/main.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// the [CollectionDropdown] widget used for selecting collections and displaying associated products
/// 
/// the [title] is a name of the selected category
/// the [width] is a width ratio of the carousel displaying products
/// 
class CollectionDropdown extends StatefulWidget {
  final List<dynamic> collectionPaths;
  final String title;
  final double width;

  const CollectionDropdown({super.key, required this.collectionPaths, required this.title, required this.width});
  
  @override
  State<StatefulWidget> createState() => _CollectionDropdownState();
}

/// the state of the widget
/// 
/// the [selectedCollection] is a selected collection
/// the [products] is products of the selected collection
/// the [collectionNamesWithIds] is a map that stores collection names as keys and their corresponding paths as values
/// 
class _CollectionDropdownState extends State<CollectionDropdown> {
  String? selectedCollection;
  String products = '';
  Map<String, String> collectionNamesWithIds = {}; 

  @override
  void initState() {
    super.initState();
    _fetchCollectionNames();
  }

  /// the [_fetchCollectionNames] function fetches collection names asynchronously
  /// 
  Future<void> _fetchCollectionNames() async {
    for (String path in widget.collectionPaths) {
      String collectionName = await _getCollectionName(path);
      collectionNamesWithIds[collectionName] = path; 
    }
    setState(() {}); 
  }

  /// the [_getCollectionName] fucntion retrieves the name of the collection from path
  /// 
  /// the [path] is a path to the collection
  /// 
  Future<String> _getCollectionName(String path) async {
    String name = 'Unknown';
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.doc(path).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      name = data['name'] ?? name;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 5,
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.title}:',
                style: const TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedCollection,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCollection = newValue;
                    products = "${collectionNamesWithIds[newValue]}/products";
                  });
                },
                items: collectionNamesWithIds.keys.map<DropdownMenuItem<String>>((String name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(
                      name
                    ),
                  );
                }).toList(),                  
                hint: const Text('Виберіть колекцію'),
              ),
            ]
          )
        ),
        if (products.isNotEmpty)
        Flexible(
          flex: 7,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(products).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return CarouselSlider.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index, _) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                                        data['photo'],
                                        fit: BoxFit.cover, // зміст фото
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
                                            data['name'],
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
                                                ' ${data['price']} грн',
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
                                            data['description'],
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
                                                      'path': document.reference.path,
                                                      'name': data['name'],
                                                      'photo': data['photo'],
                                                      'price': data['price'],
                                                      'description': data['description']
                                                    });
                                                    // get the reference to the users collection
                                                    CollectionReference users = FirebaseFirestore.instance.collection('users');

                                                    // get the current value of total cost
                                                    DocumentSnapshot userDoc = await users.doc(MyApp.userId).get();
                                                    double currentTotalCost = userDoc['totalCost'];

                                                    /// increase [totalCost] by the price of the item
                                                    double totalCost = currentTotalCost + data['price'];

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
                    child: Image.network(
                      data['photo'],
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * widget.width,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * widget.width,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                ),
              );
            },
          ),
        ), 
      ],
    );
  }
}