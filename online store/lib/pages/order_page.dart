import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/main.dart';
import 'package:cursova/widgets/orders.dart';
import 'package:flutter/material.dart';

/// the order page of the application
/// 
/// the [OrdersPage] page displays the orders
/// 
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  
  @override
  State<StatefulWidget> createState()  => _OrdersPageState();
}

/// the state of the order page
/// 
/// if [MyApp.access] is true, the page displays orders for all users
/// if [MyApp.access] is false, the page displays orders for current user
/// 
class _OrdersPageState extends State<OrdersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Замовлення',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!MyApp.access)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users/${MyApp.userId}/orders').snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final orders = snapshot.data?.docs ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final String orderId = order.id;
                    final orderData = order.data() as Map<String, dynamic>;

                    return Orders(data: orderData, id: orderId, userId: MyApp.userId);
                  },
                );
              },
            ),
            if(MyApp.access) 
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final List<QueryDocumentSnapshot> users = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: user.reference.collection('orders').snapshots(),
                          builder: (context, orderSnapshot) {
                            if (orderSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (orderSnapshot.hasError) {
                              return Text('Error: ${orderSnapshot.error}');
                            }
                            final List<QueryDocumentSnapshot> orders = orderSnapshot.data!.docs;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: orders.map((order) {
                                final String orderId = order.id;
                                final orderData = order.data() as Map<String, dynamic>;

                                return Orders(data: orderData, id: orderId, userId: user.id);
                              } ).toList(),
                            );
                          }
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}
