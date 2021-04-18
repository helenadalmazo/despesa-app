import 'dart:collection';

import 'package:despesa_app/model/expense_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryScreen extends StatelessWidget {

  final List<ExpenseCategory> _expenseCategoryList;

  ExpenseCategoryScreen(this._expenseCategoryList);

  void _select(BuildContext context, ExpenseCategory expenseCategory) {
    Navigator.pop(context, expenseCategory);
  }

  List<Widget> _getListItems(BuildContext context, List<ExpenseCategory> _expenseCategoryList, Function onTap) {
    List<Widget> widgets = [];

    if (_expenseCategoryList == null) return widgets;

    SplayTreeMap<String, List<ExpenseCategory>> _expenseCategoryListGrouped = _expenseCategoryList
        .fold(SplayTreeMap<String, List<ExpenseCategory>>(), (SplayTreeMap<String, List<ExpenseCategory>> previousValue, ExpenseCategory element) {
      previousValue.putIfAbsent(element.group, () => <ExpenseCategory>[]).add(element);
      return previousValue;
    });

    for(MapEntry<String, List<ExpenseCategory>> entry in _expenseCategoryListGrouped.entries) {
      widgets.add(
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16
          ),
          child: Text(
            entry.key,
            style: Theme.of(context).textTheme.subtitle2
          )
        )
      );
      for (ExpenseCategory expenseCategory in entry.value) {
        widgets.add(
          InkWell(
            onTap: () => onTap(context, expenseCategory),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16
              ),
              child: Row(
                children: [
                  Text(
                    expenseCategory.getEmoji(),
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "NotoColorEmoji"
                    ),
                  ),
                  SizedBox(
                    width: 8
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expenseCategory.name,
                          style: Theme.of(context).textTheme.subtitle1
                        )
                      ],
                    )
                  )
                ],
              )
            ),
          )
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Categorias"
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: Search(_expenseCategoryList, _getListItems));
              }
            )
          ],
        ),
        body: ListView(
          children: [
            ..._getListItems(context, _expenseCategoryList, _select)
          ],
        )
    );
  }
}

class Search extends SearchDelegate {
  List<ExpenseCategory> _expenseCategoryList;
  Function _getListItems;

  Search(this._expenseCategoryList, this._getListItems);

  void _select(BuildContext context, ExpenseCategory expenseCategory) {
    close(context, null);
    Navigator.pop(context, expenseCategory);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = ""
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _expenseCategoryListFiltered = query.isEmpty
        ? _expenseCategoryList
        : _expenseCategoryList.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();

    List<Widget> widgets = _getListItems(context, _expenseCategoryListFiltered, _select);

    return ListView(
      children: [
        ...widgets
      ],
    );
  }
}