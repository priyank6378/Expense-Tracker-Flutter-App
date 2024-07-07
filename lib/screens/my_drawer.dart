import 'package:expense_tracker/constants/routes.dart';
import 'package:flutter/material.dart';

class MyCustomDrawer extends StatelessWidget {
  const MyCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Center(
              child: Text(
                'Expense Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, homePageRoute, ModalRoute.withName(homePageRoute));
            },
          ),
          ListTile(
            title: const Text('History'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, historyPageRoute, ModalRoute.withName(homePageRoute));
            },
          ),
        ],
      ),
    );
  }
}