import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/main.dart';
import 'package:cursova/services/database_service.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// the account page of the application
/// 
/// the [AccountPage] page displays information of the current user
/// and allows the user to update their name and phone number
/// 
class AccountPage extends StatefulWidget {

  const AccountPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

/// the state of the account page
class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(        
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.doc('users/${MyApp.userId}').snapshots(),          
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final TextEditingController nameController = TextEditingController(text: snapshot.data?.get('name'));
            final TextEditingController phoneController = TextEditingController(text: snapshot.data?.get('phone'));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Сторінка користувача',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20), 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Email: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                          Text(
                            snapshot.data?.get('email'),
                            style: const TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Ім\'я користувача'),
                        ),
                      ),
                      const SizedBox(height: 20), 
                      // ввід пароля користувача
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Номер телефону користувача'),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]{0,10}')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Введіть ім\'я користувача!')),
                            );
                          }
                          else if (phoneController.text.length < 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Номер телефону користувача повинен складатися з 10 цифр!')),
                            );
                          }
                          else {
                            ApiService().updateUserInfo(nameController.text, phoneController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Зберегти зміни',
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
                    ],
                  )
                )
              ]
            );
          }
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}