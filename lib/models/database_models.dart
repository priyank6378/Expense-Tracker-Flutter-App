import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpensesModel {
  DateTime date;
  String title; // title of the expense
  String name; // name of the category it belongs to
  double amount;

  ExpensesModel({
    required this.date,
    required this.title,
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'name': name,
      'amount': amount,
    };
  }

  ExpensesModel.fromMap(Map<String, dynamic> map)
      : date = DateTime.parse(map['date']),
        title = map['title'],
        name = map['name'],
        amount = map['amount'];

  @override
  String toString() {
    return 'ExpensesModel{date: $date, title: $title, name: $name, amount: $amount}';
  }
}

class CategoryModel {
  String name;
  String icon;

  CategoryModel({
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }

  CategoryModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        icon = map['icon'];

  @override
  String toString() {
    return 'CategoryModel{name: $name, icon: $icon}';
  }

  Map<String, String> getIconData() {
    List<String> iconData_ = icon.split('__');

    Map<String, String> iconData = {
      'fontFamily': iconData_[0],
      'codePoint': iconData_[1],
    };

    return iconData;
  }

  // get icon as Icon
  Icon getIcon() {
    Map<String, String> iconData = getIconData();
    return Icon(
      IconData(
        int.parse(iconData['codePoint']!),
        fontFamily: iconData['fontFamily'],
      ),
    );
  }

  static Icon getIconFromString(String iconName) {
    return Icon(
      IconData(
        int.parse(iconName.split('__')[1]),
        fontFamily: iconName.split('__')[0],
      ),
    );
  }
}
