// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:expense_tracker/models/database_models.dart';
import 'package:expense_tracker/screens/widgets/total_expense_card_widget.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _fromDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0)
      .toIso8601String();
  String _toDate = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDatabase>(
      builder: (context, db, child) {
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text("Analytics"),
          //   centerTitle: true,
          // ),
          body: Center(
            child: Column(
              children: [
                // ******** DATE PICKER ********
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                _fromDate = date.toIso8601String();
                              });
                            }
                          },
                          child: Text(
                            "From",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(getFormatedDate(_fromDate)),
                      ],
                    ),
                    SizedBox(width: 15),
                    Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(0),
                              lastDate: DateTime.now(),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  _toDate = date.toIso8601String();
                                });
                              }
                            });
                          },
                          child: Text(
                            "To",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(getFormatedDate(_toDate)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // ******** EXPENSES CARD ********
                TotalExpenseCard(
                  fromDate: getDateWithoutTime(_fromDate),
                  toDate: getDateWithoutTime(_toDate),
                ),

                SizedBox(height: 25),

                // ******** EXPENSES GRAPH BY CATEGORY ********
                // Container(
                //   height: 2,
                //   color: Colors.grey[400],
                // ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      title: Text("Category",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      trailing: Text("Total",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                ),

                // Container(
                //   height: 2,
                //   color: Colors.grey[400],
                // ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: db.categoryWiseTotalExpensesFromToDate(
                        getDateWithoutTime(_fromDate),
                        getDateWithoutTime(_toDate)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // snapshot.data = List<(String, double)>
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
                            itemCount: snapshot.data != null
                                ? snapshot.data!.length
                                : 0,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Card(
                                  elevation: 10,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: ShapeBorder.lerp(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      1.0),
                                  child: ListTile(
                                    title: Text(snapshot.data![index].$1,
                                        style: TextStyle(fontSize: 15)),
                                    trailing: Text(
                                      "${snapshot.data![index].$2.toString()} \$",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// get the current date from datetime in format dd-mm-yyyy
String getFormatedDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate =
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString()}";
  return formattedDate;
}

String getDateWithoutTime(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate =
      "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  return formattedDate;
}
