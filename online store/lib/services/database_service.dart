import 'package:cursova/pages/cart_page.dart';
import 'package:cursova/main.dart';
import 'package:cursova/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// the [ApiService] class is a service class for API interactions
/// 
class ApiService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// the [register] function registers a new user with the provided [email], [password], [name] and [phone]
  /// 
  /// upon successful registration, the user's name and phone are updated, and the user is added to the 'users' collection
  /// the user is the redirected to the home page
  /// 
  /// if registration fails, a snackbar with the error message is displayed
  /// 
  Future<void> register(String email, String password, String name, String phone, BuildContext context ) async {
    try {
      // create a new user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // update the user's name and phone number
      await userCredential.user!.updateDisplayName(name);

      // add user to the 'users' collection
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'totalCost': 0,
        'access': false,
      });

      // execute a query to Firestore to retrieve the document ID based on the email
      QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userCredential.user!.email)
        .get();

      // check if a document with the specified email has been found
      if (querySnapshot.docs.isNotEmpty) {

        // retrieve the ID of the first found document
        MyApp.userId = querySnapshot.docs.first.id;
        DocumentSnapshot userDoc = querySnapshot.docs[0];
        MyApp.access = userDoc['access'];
      }

      // redirect the user to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    } 

    // if registration fails, a snackbar with the error message is displayed
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register. ${e.message}')),
      );

    } 
  }

  /// the [login] function logs in a user with the provided [email] and [password]
  /// 
  /// upon successful login, the user is redirected to the home page
  /// 
  /// if login fails, a snackbar with the error message is displayed
  /// 
  Future<void> login(String email, String password, BuildContext context ) async {
    try {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // execute a query to Firestore to retrieve the document ID based on the email
      QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userCredential.user!.email)
        .get();

      
      // check if a document with the specified email has been found
      if (querySnapshot.docs.isNotEmpty) {
        // retrieve the ID of the first found document
        MyApp.userId = querySnapshot.docs.first.id;
        DocumentSnapshot userDoc = querySnapshot.docs[0];
        MyApp.access = userDoc['access'];
      }
      
      // redirect the user to the home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    } 

    // if login fails, a snackbar with the error message is displayed
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in. ${e.message}')),
      );
    }
  }

  /// the [signOut] function signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// the [getCurrentUser] function retrieves information about the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// the [confirm] function confirms an order with the provided [address]
  /// 
  /// the order details are saved to Firestore, and the user's shopping cart is cleared
  /// 
  Future<void> confirm(String address) async {
    DocumentSnapshot user = await _firestore.collection('users').doc(MyApp.userId).get();
    double totalCost = user['totalCost'];

    DocumentReference newOrderRef = await _firestore.collection('users/${MyApp.userId}/orders').add({
      'totalCost': totalCost,
      'address': address,
      'date': DateTime.now(),
      'progress': false
    });

    String path = newOrderRef.path;

    for (Map<String, dynamic> product in CartPage.products) {
      await FirebaseFirestore.instance.collection('$path/products').doc().set({
        'path': product['path'],
        'name': product['name'],
        'photo': product['photo'],
        'price': product['price'],
        'description': product['description']
      });
    }

    var collectionRef = FirebaseFirestore.instance.collection('users/${MyApp.userId}/shoppingCart');
    var batch = FirebaseFirestore.instance.batch();

    await collectionRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
    });

    await batch.commit();

    // Видалення самої колекції
    await collectionRef.doc(collectionRef.id).delete();

    updateTotalCost(0);

    CartPage.products = [];
  }

  /// the [updateTotalCost] function updates the total cost of the user's shopping cart
  ///  
  /// the [totalCost] is a total cost
  /// 
  void updateTotalCost (double totalCost) {
    _firestore.collection('users').doc(MyApp.userId).update({'totalCost': totalCost});
  }

  /// the [updateProduct] function updates the details of a product in Firestore
  /// 
  /// the [id] is a path to the product
  /// the [photo] is a path to the photo
  /// the [name] is a name of the product
  /// the [price] is a price of the product
  /// the [description] is a description of the product
  /// 
  void updateProduct(String id, String photo, String name, double price, String description) {
    _firestore.doc(id).update({'name': name, 'price': price, 'photo': photo, 'description': description});
  }

  /// the [addNewProduct] function adds a new product to Firestore
  /// 
  /// the [id] is a path to the 'product' collection
  /// the [photo] is a path to the photo
  /// the [name] is a name of the product
  /// the [price] is a price of the product
  /// the [description] is a description of the product
  /// 
  void addNewProduct(String id, String photo, String name, double price, String description) {
    _firestore.collection(id).doc().set({'name': name, 'price': price, 'photo': photo, 'description': description});
  }

  /// the [deleteElement] function deletes a document from Firestore
  /// 
  /// the [path] is a path to the element of the collection
  /// 
  void deleteElement(String path) {
    _firestore.doc(path).delete();
  }

  /// the [updateUserInfo] function updates user information in Firestore
  /// 
  /// the [name] is a name of the user
  /// the [phone] is a phone number of the user
  /// 
  void updateUserInfo (String name, String phone) {
    _firestore.collection('users').doc(MyApp.userId).update({'name': name, 'phone': phone});
  }

  /// the [allProducts] function retrieves all products from Firestore
  /// 
  /// the [path] is a path to the collection
  /// 
  /// the [allProducts] function returns a list of document snapshots containing product data
  /// 
  Future<List<DocumentSnapshot<Object?>>> allProducts(List<QueryDocumentSnapshot> path) async {

    List<DocumentSnapshot<Object?>> allProducts = [];

    for (DocumentSnapshot category in path) {
      QuerySnapshot subcategories= await FirebaseFirestore.instance
        .collection('${category.reference.path}/subcategories')
        .get();

      for (DocumentSnapshot subcategory in subcategories.docs) {
        QuerySnapshot products = await FirebaseFirestore.instance
        .collection('${subcategory.reference.path}/products')
        .get();

        for (DocumentSnapshot product in products.docs) {
          allProducts.add(product);
        }
      }
    }

    return allProducts;
  }

  /// the [subcategoryProducts] function retrieves all products of a subcategory from Firestore
  /// 
  /// the [path] is a path to the subcategory
  /// 
  /// the [subcategoryProducts] function returns a list of document snapshots containing product data
  /// 
  Future<List<DocumentSnapshot<Object?>>> subcategoryProducts(List<QueryDocumentSnapshot> path) async {
    List<DocumentSnapshot<Object?>> allProducts = [];

    for (DocumentSnapshot subcategory in path) {

      QuerySnapshot products = await FirebaseFirestore.instance
        .collection('${subcategory.reference.path}/products')
        .get();

      allProducts.addAll(products.docs);
    }
    
    return allProducts;
  }

  /// the [deleteImage] function deletes an image file from Firebase Storage
  /// 
  /// the [imageUrl] is a path to the image
  /// 
  Future<void> deleteImage(String imageUrl) async {
   // Отримуємо посилання на файл у Firebase Storage за URL
    Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

    // Видаляємо файл з Firebase Storage
    await storageRef.delete();
  }
}