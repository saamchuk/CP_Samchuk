import 'package:cursova/widgets/collectionDropdown.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:flutter/material.dart';

/// the combination page of the application
/// 
/// the [CombinationPage] page allows users to combine clothing
/// 
/// the [top] is a list of paths to top clothing items
/// the [bottom] is a list of paths to bottom clothing items
/// the [title] is a name of the selected category
/// 
class CombinationPage extends StatefulWidget {

  final List<dynamic> top;
  final List<dynamic> bottom;
  final String title;

  const CombinationPage({super.key, required this.top, required this.bottom, required this.title});

  @override
  State<StatefulWidget> createState() => _CombinationPage();

}

/// the state of the combination page
class _CombinationPage extends State<CombinationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CollectionDropdown(collectionPaths: widget.top, title: "Верхня частина образу", width: 0.3),
            CollectionDropdown(collectionPaths: widget.bottom, title: "Нижня частина образу", width: 0.5)
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}