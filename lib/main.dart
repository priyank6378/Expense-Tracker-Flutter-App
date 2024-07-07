import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/screens/add_category_page.dart';
import 'package:expense_tracker/screens/add_expense_page.dart';
import 'package:expense_tracker/screens/analytics_page.dart';
import 'package:expense_tracker/screens/dashboard.dart';
import 'package:expense_tracker/screens/history.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:expense_tracker/themes/dark_theme.dart';
import 'package:expense_tracker/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyDatabase.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: customLightTheme,
      // darkTheme: customDarkTheme,
      routes: {
        dashboardPageRoute: (context) => const DashboardPage(),
        homePageRoute: (context) => const HomePage(),
        historyPageRoute: (context) => const HistoryPage(),
        addExpensePageRoute: (context) => const AddExpensePage(),
        addCategorypageRoute: (context) => const AddCategoryPage(),
        analyticsPageRoute: (context) => const AnalyticsPage(),
      },
      // home: const AddCategoryPage(),
    );
  }
}
