import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursova/pages/combination_page.dart';
import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:flutter/material.dart';

/// the combination page of the application
/// 
/// the [CombinationMainPage] page allows users to select a category for combination of the clother
/// 
class CombinationMainPage extends StatefulWidget {

  const CombinationMainPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _CombinationMainPage();

}

/// the state of the combination page
class _CombinationMainPage extends State<CombinationMainPage> {

  _CombinationMainPage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [ 
            const SizedBox(height: 20),
            const Text(
              'Оберіть категорію',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('combination').snapshots(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final categories = snapshot.data?.docs ?? [];

                return ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final categoryData = category.data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(
                            categoryData['name'],
                            style: const TextStyle(
                              fontSize: 20
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: ()  {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => CombinationPage(top: categoryData['top'], bottom: categoryData['bottom'], title: categoryData['name']))
                            );
                          },
                        );
                      },
                    );
              }
            )
            
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}