import 'package:expense_tracker/constants/available_icons.dart';
import 'package:expense_tracker/models/database_models.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase extends ChangeNotifier {
  // DATABASE CONSTANTS
  String dbName = 'database.db';
  String expenseTableName = 'expense';
  String categoryTableName = 'category';
  int version = 1;

  // private constructor to prevent external instantiation
  MyDatabase._privateConstructor();

  // single instance of database
  static final MyDatabase instance = MyDatabase._privateConstructor();

  // singleton databse
  static Database? _database;

  // Database getter
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // database initializer
  Future<Database?> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    // creating 'expenses' table
    batch.execute('''
      CREATE TABLE $expenseTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT, 
        title TEXT,
        name TEXT, 
        amount REAL
      )
      ''');

    // creating 'category' table
    batch.execute('''
      CREATE TABLE $categoryTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        icon TEXT
      )
      ''');

    // commiting
    await batch.commit();
  }

  // close the database
  Future close() async {
    final db = await database;
    if (db != null) db.close();
  }

  // *********************************************************************
  // *************************** EXPENSES TABLE **************************
  // *********************************************************************

  // insert a new expense
  Future<void> insertExpense(ExpensesModel expense) async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    // debugging
    // print(expense);

    expense.title = expense.title.substring(0, 1).toUpperCase() +
        expense.name.substring(1).toLowerCase();

    await db.insert(
      expenseTableName,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  // get all expenses for the today
  Future<List<ExpensesModel>> todayExpenses() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> todayExpenses = await db.query(
      expenseTableName,
      where: 'DATE(date) = ?',
      whereArgs: [getTodayDate()],
    );

    final List<ExpensesModel> expenses = todayExpenses
        .map((e) => ExpensesModel.fromMap(e))
        .toList()
        .reversed
        .toList();

    return expenses;
  }

  // get all this months expenses
  Future<List<ExpensesModel>> monthlyExpenses() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final startDate = DateTime.now()
        .subtract(Duration(days: DateTime.now().day - 1))
        .toString()
        .split(' ')
        .first;
    final endDate = DateTime.now()
        .add(Duration(days: DateTime.now().day - 1))
        .toString()
        .split(' ')
        .first;

    final List<Map<String, Object?>> monthlyExpenses = await db.query(
      expenseTableName,
      where: 'DATE(date) BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );

    final List<ExpensesModel> expenses;
    expenses = monthlyExpenses
        .map((e) => ExpensesModel.fromMap(e))
        .toList()
        .reversed
        .toList();
    return expenses;
  }

  // get category wise total total expense
  Future<List<Map<String, dynamic>>> categoryWiseTodayExpenses() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    String todayDate = getTodayDate();

    final List<Map<String, Object?>> totalExpenses = await db.rawQuery('''
      SELECT name, SUM(amount) as total 
      FROM $expenseTableName 
      WHERE DATE(date) = ?
      GROUP BY name
      ''', [todayDate]);

    return totalExpenses;
  }

  // get category wise monthly total expense
  Future<List<(String, double)>> categoryWiseTotalExpensesFromToDate(
      String startDate, String endDate) async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> monthlyExpenses = await db.rawQuery(
      '''
      SELECT name, SUM(amount) as total 
      FROM $expenseTableName 
      WHERE DATE(date) BETWEEN ? AND ? 
      GROUP BY name
      ''',
      [startDate, endDate],
    );

    final List<(String, double)> totalExpenses = [];

    for (int i = 0; i < monthlyExpenses.length; i++) {
      if (monthlyExpenses[i]['total'] as double < 0) {
        totalExpenses.add(
          (
            monthlyExpenses[i]['name'] as String,
            -(monthlyExpenses[i]['total'] as double)
          ),
        );
      }
    }
    // sorting from highest to lowest
    totalExpenses.sort((a, b) => b.$2.compareTo(a.$2));

    return totalExpenses;
  }

  // get category wise expense from date to end date
  Future<List<Map<String, dynamic>>> categoryWiseExpenses(
      String startDate, String endDate) async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> expenses = await db.rawQuery(
      '''
      SELECT name, SUM(amount) as total 
      FROM $expenseTableName 
      WHERE DATE(date) BETWEEN ? AND ? 
      GROUP BY name
      ''',
      [startDate, endDate],
    );

    return expenses;
  }

  Future<double> totalMonthsAmount(
      String startDate, String endDate, String typeOfExpense) async {
    final monthlyExpenses = await categoryWiseExpenses(startDate, endDate);

    double totalAmount = 0;

    for (int i = 0; i < monthlyExpenses.length; i++) {
      if (typeOfExpense == 'expense') {
        if (monthlyExpenses[i]['total'] < 0) {
          totalAmount -= monthlyExpenses[i]['total'];
        }
      } else if (typeOfExpense == 'income') {
        if (monthlyExpenses[i]['total'] > 0) {
          totalAmount += monthlyExpenses[i]['total'];
        }
      }
    }
    return totalAmount;
  }

  // *********************************************************************
  // *************************** CATEGORY TABLE **************************
  // *********************************************************************

  // insert a new category
  Future<void> insertCategory(CategoryModel category) async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> x = await db.query(
      categoryTableName,
      where: 'name = ?',
      whereArgs: [category.name],
    );

    if (x.length > 0) {
      SnackBar(content: Text('Category already exists'));
      return;
    }

    category.name = category.name.substring(0, 1).toUpperCase() +
        category.name.substring(1).toLowerCase();

    await db.insert(
      categoryTableName,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  // get all categories
  Future<Map<String, String>> allCategories() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> categories =
        await db.query(categoryTableName);

    final Map<String, String> allCategories = {};
    for (int i = 0; i < categories.length; i++) {
      allCategories[categories[i]['name'] as String] =
          categories[i]['icon'] as String;
    }

    print(allCategories);

    return allCategories;
  }

  // get the set of all icons used
  Future<List<IconData>> getUsedIcons() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<Map<String, Object?>> icons = await db.rawQuery('''
      SELECT icon
      FROM $categoryTableName
      ''');

    final List<IconData> usedIcons = [];
    for (int i = 0; i < icons.length; i++) {
      String iconFontFamily = (icons[i]['icon'] as String).split('__')[0];
      String iconCodePoint = (icons[i]['icon'] as String).split('__')[1];
      usedIcons.add(IconData(
        int.parse(iconCodePoint),
        fontFamily: iconFontFamily,
      ));
    }

    return usedIcons;
  }

  // get the set of all icons available
  Future<List<IconData>> getAvailableIcons() async {
    final db = await database;

    if (db == null) {
      throw Exception('Database not available');
    }

    final List<IconData> usedIcons = await getUsedIcons();

    final List<IconData> availableIcons = [];

    // all available icons
    for (int i = 0; i < availableIconsCategory.length; i++) {
      if (!usedIcons.contains(availableIconsCategory.elementAt(i))) {
        availableIcons.add(availableIconsCategory.elementAt(i));
      }
    }

    return availableIcons;
  }
}

// //
/////////////// Helper Functions /////////////////

String getTodayDate() {
  return DateTime.now().toIso8601String().split('T').first;
}

// //
