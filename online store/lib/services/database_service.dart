import 'package:cursova/pages/cart_page.dart';
import 'package:cursova/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Реєстрація нового користувача
  Future<void> register(String email, String password, String name, String phone, BuildContext context ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Оновлюємо ім'я користувача та номер телефону
      await userCredential.user!.updateDisplayName(name);

      // Додаємо нового користувача до колекції users
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'totalCost': 0,
        'access': false,
      });

      // Виконуємо запит до Firestore для отримання ID документу за email
      QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userCredential.user!.email)
        .get();

      // Перевіряємо, чи було знайдено документ з вказаним email
      if (querySnapshot.docs.isNotEmpty) {

        // Отримуємо ID першого знайденого документу
        MyApp.userId = querySnapshot.docs.first.id;
        DocumentSnapshot userDoc = querySnapshot.docs[0];
        MyApp.access = userDoc['access'];
      }

      // Перенаправляємо користувача на головну сторінку
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    } 

    on FirebaseAuthException catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register. ${e.message}')),
      );

    } 
  }

  // Вхід користувача
  Future<void> login(String email, String password, BuildContext context ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Виконуємо запит до Firestore для отримання ID документу за email
      QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userCredential.user!.email)
        .get();

      // Перевіряємо, чи було знайдено документ з вказаним email
      if (querySnapshot.docs.isNotEmpty) {
        // Отримуємо ID першого знайденого документу
        MyApp.userId = querySnapshot.docs.first.id;
        DocumentSnapshot userDoc = querySnapshot.docs[0];
        MyApp.access = userDoc['access'];
      }
      
      // Ви можете перенаправити користувача на головну сторінку після успішного входу
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    } 
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in. ${e.message}')),
      );
    }
  }

  // Вихід користувача
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Отримання інформації про поточного користувача
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Оформлення замовлення
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
        'price': product['price']
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

    MyApp.totalCost = 0;

    updateTotalCost();

    CartPage.products = [];
  }

  // оновлення значення загальної суми кошика користувача
  void updateTotalCost () {
    _firestore.collection('users').doc(MyApp.userId).update({'totalCost': MyApp.totalCost});
  }

  void updateUserInfo (String name, String phone) {
    _firestore.collection('users').doc(MyApp.userId).update({'name': name, 'phone': phone});
  }

  // отримання всіх товарів
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

  

  // отримання всіх товарів підкатегорії
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

  Future<void> deleteImage(String imageUrl) async {
   // Отримуємо посилання на файл у Firebase Storage за URL
    Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

    // Видаляємо файл з Firebase Storage
    await storageRef.delete();
  }

  
}
