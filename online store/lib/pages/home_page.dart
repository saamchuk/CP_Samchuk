import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:flutter/material.dart';

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
            //TopList(width: 10),
          ],
        ),
      ),
      drawer: DrawerMenu(),
    );
  }
}