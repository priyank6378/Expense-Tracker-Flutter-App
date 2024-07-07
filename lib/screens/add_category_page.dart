// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/models/database_models.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  // final db = MyDatabase.instance;

  final TextEditingController _categoryNameController = TextEditingController();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDatabase>(
      builder: (context, db, child) {
        return Scaffold(
          appBar: AppBar(),
          body: FutureBuilder(
            future: db.getAvailableIcons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              controller: _categoryNameController,
                              decoration: InputDecoration(
                                labelText: 'Category Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () async {
                              String iconDataForDatabase =
                                  "${snapshot.data![_selectedIndex].fontFamily.toString()}__${snapshot.data![_selectedIndex].codePoint}";
                              db.insertCategory(
                                CategoryModel(
                                  name: _categoryNameController.text,
                                  icon: iconDataForDatabase,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text('Add',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 5,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                icon: Icon(
                                  snapshot.data![index],
                                  color: _selectedIndex == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
