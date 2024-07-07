import 'package:expense_tracker/models/database_models.dart';
import 'package:expense_tracker/service/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomListOfTransactionsWidget extends StatefulWidget {
  const CustomListOfTransactionsWidget({super.key});

  @override
  State<CustomListOfTransactionsWidget> createState() =>
      CustomListOfTransactionsWidgetState();
}

class CustomListOfTransactionsWidgetState
    extends State<CustomListOfTransactionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyDatabase>(
      builder: (context, db, child) {
        return Expanded(
          child: FutureBuilder(
            future: db.monthlyExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FutureBuilder(
                    future: db.allCategories(),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Theme.of(context).colorScheme.secondary,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: ListTile(
                              leading: CategoryModel.getIconFromString(snapshot1
                                  .data![snapshot.data![index].name]!
                                  .toString()),
                              title: Text(snapshot.data![index].title),
                              subtitle: Text(
                                snapshot.data![index].name.toString(),
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    '${snapshot.data![index].amount.toString()} \$',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // color: snapshot.data![index].amount > 0
                                      //     ? Theme.of(context).colorScheme.primary
                                      //     : Theme.of(context)
                                      //         .colorScheme
                                      //         .secondary,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data![index].date.toString().split(' ')[0]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
