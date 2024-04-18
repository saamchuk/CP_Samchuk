import 'package:cursova/widgets/customAppBar.dart';
import 'package:cursova/widgets/drawerMenu.dart';
import 'package:cursova/widgets/listProduct.dart';
import 'package:flutter/material.dart';

/// the product catalog page of the application
/// 
/// the [SubCategoriesPage] page displays subcategories or products based on the specified path
/// 
class SubCategoriesPage extends StatefulWidget {
  const SubCategoriesPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _SubCategoriesPageState();

}

/// the state of the product catalog page
/// 
/// the [path] is a path to the collection or current category or subcategory
/// the [category] is a path to the collection or current category
/// the [all] variable indicates if it's categories
/// the [subcategories] variable indicates if it's subcategories
/// the [nameCategory] is a title for the category list
/// the [nameProducts] is a title for the products
/// 
class _SubCategoriesPageState extends State<SubCategoriesPage> {
  String path = 'categories'; 
  String category = 'categories'; 
  bool all = true; 
  bool subcategories = true; 
  String nameCategory = "Категорії"; 
  String nameProducts = "Товари";
  
  _SubCategoriesPageState();

  /// updates the path
  /// 
  /// the [_updatePath] function retrieves a [newPath] 
  /// 
  /// the [newPath] is a path to the collection or current category or subcategory
  /// 
  /// if [all] is true, it sets [all] to false; otherwise, it sets [subcategories] to false
  /// 
  void _updatePath(String newPath) {
    setState(() {
      path = newPath;
      if (all) {
        all = false;
      }
      else {
        subcategories = false;
      }
    });
  }

  /// updates the name
  /// 
  /// the [_updateName] function retrieves a [newName]
  /// 
  /// the [newName] is a title
  /// 
  /// if [subcategories] is true, it updates [nameCategory]; otherwise, it updates [nameProducts]
  /// 
  void _updateName(String newName) {
    setState(() {
      if (subcategories) {
        nameCategory = newName;
      }
      else {
        nameProducts = newName;
      }
    });
  }

  /// updates the category
  /// 
  /// the [_updateCategory] function retrieves a [newCategory] and updates [category]
  /// 
  /// the [newCategory] is a a path to the collection
  /// 
  void _updateCategory(String newCategory) {
    setState(() {
      category = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ 
            ListProduct(path: path, onUpdatePath: _updatePath, subcategories: subcategories, category: category, all: all, onUpdateName: _updateName, nameCategory: nameCategory, onUpdateCategory: _updateCategory, nameProducts: nameProducts),
          ]
        )
      ),
      drawer: const DrawerMenu(),
    );
  }
}