// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expense_tracker/models/database_models.dart';
import 'package:expense_tracker/screens/my_drawer.dart';
import 'package:expense_tracker/screens/widgets/list_of_history_widget.dart';
import 'package:expense_tracker/screens/widgets/total_expense_card_widget.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ********* EXPENSE AMOUNT CARD ***********
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This ",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
              Text(
                "Months ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Text(
                "Data",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ],
          ),
        ),

        TotalExpenseCard(
          fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1)
              .toIso8601String(),
          toDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
              .toIso8601String(),
        ),

        // ********* HISTORY ***********
        const Card(
          margin: EdgeInsets.symmetric(horizontal: 30),
          elevation: 0,
          child: ListTile(
            title: Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        CustomListOfTransactionsWidget(),
      ],
    );
  }
}
