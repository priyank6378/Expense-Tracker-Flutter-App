import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/screens/analytics_page.dart';
import 'package:expense_tracker/screens/history.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pagesList = [
    HomePage(),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        centerTitle: true,
        // title: const Text("Dashboard"),
      ),

      // floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // go to add expense page
          Navigator.pushNamed(context, addExpensePageRoute);
        },
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          // gradient color
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? Theme.of(context).colorScheme.onTertiary
                      : Colors.black,
                ),
                onPressed: () {
                  // go to home page
                  _changeIndex(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.analytics_outlined,
                  color: _currentIndex == 1
                      ? Theme.of(context).colorScheme.onTertiary
                      : Colors.black,
                ),
                onPressed: () {
                  // go to history page
                  _changeIndex(1);
                },
              ),
            ],
          ),
        ),
      ),

      // body
      body: _pagesList[_currentIndex],
    );
  }
}
