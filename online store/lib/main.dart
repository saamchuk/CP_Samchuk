import 'package:cursova/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/productTile.dart';
import 'widgets/customAppBar.dart';
import 'widgets/drawerMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      storageBucket: "saamchuk-7173f.appspot.com",
      apiKey: "AIzaSyD3ZKD85fEASsy0UNzZTukriV--I5M0Z0w",
      appId: "1:344417111025:web:fc7bab93052ed080bed250",
      messagingSenderId: "344417111025", 
      projectId: "saamchuk-7173f"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static String userId = '';
  static bool access = false;
  static double totalCost = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),

      routes: {
        '': (context) => HomePage(),
        '/newpage': (context) => LoginPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        //padding: EdgeInsets.only(right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text(
              'Топові товари',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20,),
            TopList(width: 10),
          ],
        ),
      ),
      drawer: DrawerMenu(),
    );
  }
}

class TopList extends StatelessWidget {
  final int width;

  const TopList({super.key,required this.width});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('top').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final allPath = snapshot.data?.docs ?? [];

        return FutureBuilder<List<DocumentSnapshot>>(
          future: _getProducts(allPath),
          builder: (context, productSnapshot) {
            /*if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }*/
            if (productSnapshot.hasError) {
              return Text('Error: ${productSnapshot.error}');
            }

            final products = productSnapshot.data ?? [];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / width), // Відступи зліва та справа
              child: Align (
                alignment: Alignment.center,
                child: Wrap(// відстань між карточками по вертикалі
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    products.length,
                    (index) => ProductTile(
                      button: true,
                      update: false,
                      id: products[index].reference.path,
                      name: products[index].get('name'),
                      price: products[index].get('price'),
                      imageUrl: products[index].get('photo'),
                    ),
                  ).toList(),
                )
              )
            );
          },
        );
      },
    );
  }
}

Future<List<DocumentSnapshot>> _getProducts(List<QueryDocumentSnapshot> productPaths) async {
  List<DocumentSnapshot> products = [];
  for (QueryDocumentSnapshot productPath in productPaths) {
    DocumentSnapshot product = await FirebaseFirestore.instance.doc(productPath['path']).get();
    products.add(product);
  }
  return products;
}

/*class CategoriesList extends StatelessWidget{

  const CategoriesList({super.key});

  static Future<List<DocumentSnapshot<Object?>>> allProducts() async {

    List<DocumentSnapshot<Object?>> allProducts = [];

    QuerySnapshot categories= await FirebaseFirestore.instance
        .collection('categories')
        .get();

    for (DocumentSnapshot category in categories.docs){
      QuerySnapshot subcategories= await FirebaseFirestore.instance
        .collection('categories/${category.id}/subcategories')
        .get();

      for (DocumentSnapshot subcategory in subcategories.docs) {
        QuerySnapshot products = await FirebaseFirestore.instance
        .collection('categories/${category.id}/subcategories/${subcategory.id}/products')
        .get();

        for (DocumentSnapshot product in products.docs) {
          allProducts.add(product);
        }
      }
    }

    allProducts.sort((a, b) {
      int numberViewsA = a['numberViews'] ?? 0;
      int numberViewsB = b['numberViews'] ?? 0;
      return numberViewsB.compareTo(numberViewsA);
    });

    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Object?>>>(
      future: allProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<DocumentSnapshot<Object?>> allProducts = snapshot.data ?? [];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7), // Відступи зліва та справа
          child: Wrap(// відстань між карточками по вертикалі
            alignment: WrapAlignment.center,
            children: List.generate(
              allProducts.length <= 6 ? allProducts.length : 6 ,
              (index) => ProductTile(
                button: true,
                id: allProducts[index].reference.path,
                name: allProducts[index].get('name'),
                price: allProducts[index].get('price'),
                imageUrl: allProducts[index].get('photo'),
              ),
            ).toList(),
          )
        );
      },
    );
  }
}*/