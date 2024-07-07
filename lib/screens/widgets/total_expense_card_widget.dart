// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalExpenseCard extends StatefulWidget {
  const TotalExpenseCard(
      {super.key, required this.fromDate, required this.toDate});

  final String fromDate;
  final String toDate;

  @override
  State<TotalExpenseCard> createState() => TotalExpenseCardState();
}

class TotalExpenseCardState extends State<TotalExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyDatabase>(
      builder: (context, db, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  FutureBuilder(
                    future: db.totalMonthsAmount(
                        widget.fromDate, widget.toDate, 'expense'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          "-${snapshot.data} \$",
                          style: TextStyle(
                            color: Colors.red[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        );
                      }
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Income",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  FutureBuilder(
                    future: db.totalMonthsAmount(
                        widget.fromDate, widget.toDate, 'income'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          "+${snapshot.data} \$",
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        );
                      }
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
