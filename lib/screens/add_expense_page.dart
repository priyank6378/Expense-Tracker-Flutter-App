// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/database_models.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  String _type = "expense";

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(addCategorypageRoute);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: Text(
                "Add Category",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Consumer<MyDatabase>(
          builder: (context, db, child) {
            return FutureBuilder(
              future: db.allCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Expense Details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: "Title",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: "Amount",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // category selctor dropdown menu
                      DropdownMenu<CategoryModel>(
                        width: MediaQuery.of(context).size.width * 0.8,
                        controller: _categoryController,
                        enableFilter: true,
                        requestFocusOnTap: true,
                        leadingIcon: Icon(Icons.search),
                        label: Text("Category"),
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        onSelected: (value) {
                          _categoryController.text = value!.name;
                        },
                        dropdownMenuEntries: [
                          for (var category in snapshot.data!.keys)
                            DropdownMenuEntry(
                              value: CategoryModel(
                                  name: category,
                                  icon: snapshot.data![category]!),
                              label: category,
                              leadingIcon: CategoryModel.getIconFromString(
                                  snapshot.data![category]!),
                            ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // expense or income
                      // radio button
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Expense"),
                            Radio(
                              value: _type,
                              groupValue: "expense",
                              onChanged: (value) {
                                setState(() {
                                  _type = 'expense';
                                });
                              },
                            ),
                            Text("Income"),
                            Radio(
                              value: _type,
                              groupValue: "income",
                              onChanged: (value) {
                                setState(() {
                                  _type = 'income';
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.tertiary),
                        ),
                        onPressed: () {
                          // add expense
                          try {
                            if (_titleController.text.isEmpty ||
                                _amountController.text.isEmpty ||
                                _categoryController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }
                            double amount =
                                double.parse(_amountController.text);
                            if (_type == 'expense') {
                              amount = -amount;
                            }
                            db.insertExpense(
                              ExpensesModel(
                                title: _titleController.text,
                                amount: amount,
                                name: _categoryController.text,
                                date: DateTime.now(),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Expense added successfully"),
                              ),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error adding expense"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Add Expense",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        ));
  }
}
