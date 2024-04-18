import 'package:cursova/widgets/orderElements.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// the [OrderDetailsPage] page displays the details of an order
/// 
/// the [orderId] is an ID of the order
/// the [date] is a date of the order's confirm 
/// the [totalCost] is a total cost of the order
/// the [userId] is an ID of the user who made the order
/// the [address] is a delivery address of the order
/// 
class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  final DateTime date;
  final double totalCost;
  final String userId;
  final String address;

  const OrderDetailsPage({super.key, required this.orderId, required this.date, required this.totalCost, required this.userId, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі замовлення'),
        backgroundColor: Colors.blue.shade200,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Дата: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  DateFormat('dd-MM-yyyy HH:mm').format(date),
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
              ]
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Загальна сума: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  '$totalCost грн',
                  style: const TextStyle(
                    fontSize: 20
                  ),
                )
              ]
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Адреса доставки: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 20
                  ),
                )
              ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Товари:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OrderElements(path: 'users/${userId}/orders/${orderId}/products', button: false, width: 10),
          ]
        ),
      )
    );
  }
}