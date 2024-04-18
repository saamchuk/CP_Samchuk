import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/main.dart';
import 'package:cursova/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// the [Orders] widget displays order information
/// 
/// the [data] is a data for the order
/// the [id] is an ID of the order
/// the [userId] is an ID of the user who placed the order
/// 
class Orders extends StatelessWidget{
  final Map<String, dynamic> data;
  final String id;
  final String userId;

  const Orders({required this.data, super.key, required this.id, required this.userId});

  @override
  Widget build (BuildContext context) {
    return Center (
      child: Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              Expanded(
                child: Text('Дата: ${DateFormat('dd-MM-yyyy HH:mm').format(data['date'].toDate())}'),
              ),
              const SizedBox(width: 30),
              if (data['progress'])
                const Expanded ( 
                  child: Text(
                    'Статус: виконано', 
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                )
              else 
                const Expanded ( 
                  child: Text(
                    'Статус: в процесі...', 
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
            ],
          ),
          subtitle: Text('Загальна сума: ${data['totalCost']} грн'),
                            
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: [
                if (MyApp.access && !data['progress'])
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('users/${userId}/orders').doc(id).update({'progress': true});
                    },
                    child: const Icon(Icons.done)
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(orderId: id, date: data['date'].toDate(), totalCost: data['totalCost'], userId: userId, address: data['address']),
                      ),
                    );
                  },
                  child: const Text('Детальніше')
                )
              ]
            )
          ),
        ),
      )
    );
  }
}