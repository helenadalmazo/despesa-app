import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/exception/not_found_exception.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/expense_repository.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/utils/text_form_field_validator.dart';
import 'package:despesa_app/widget/list_header.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  final int id;

  const GroupScreen({Key key, this.id}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  Group _group;

  List<Expense> _expenses = [];

  bool _loading = true;

  int _bottomNavigationCurrentIndex = 0;

  final TextEditingController _userNameTextEditingController = TextEditingController();

  final PageController _pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();
    _load().then((_) {
      setState(() {
        _loading = true;
      });
    });
  }

  Future<void> _load() async {
    await _listExpenses();
    await _getGroup();
  }

  Future<void> _listExpenses() async {
    List<Expense> list = await ExpenseRepository.instance.list();
    setState(() {
      _expenses = list;
    });
  }

  Future<void> _getGroup() async {
    Group get = await GroupRepository.instance.get(widget.id);
    setState(() {
      _group = get;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _bottomNavigationCurrentIndex = index;
    });
  }

  void _onTapButtonNavigation(int index) {
    setState(() {
      _bottomNavigationCurrentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease
      );
    });
  }

  String _getUserNameText(User user) {
    bool isCurrentUser = Authentication.instance.currentUser.username == user.username;
    return '${user.fullName} ${isCurrentUser ? '(Você)' : ''}';
  }

  void _addUser(BuildContext context, String username) async {
    try {
      Group addUser = await GroupRepository.instance.addUser(_group.id, username);
      setState(() {
        _group = addUser;
      });
    } on NotFoundException catch(notFoundException) {
      final snackBar = SnackBar(
        content: Text(notFoundException.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _removeUser(int userId) async {
    Group removeUser = await GroupRepository.instance.removeUser(_group.id, userId);
    setState(() {
      _group = removeUser;
    });
  }

  void _showDeleteUserDialog(BuildContext context, int userId) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover grupo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você quer realmente remover esse usuário do grupo?'),
              ],
            ),
          ),
          actions: <Widget> [
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                _removeUser(userId);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showUserModalBottomSheet(Map<String, dynamic> params) {
    BuildContext context = params['context'];

    _userNameTextEditingController.text = "";

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalBottomSheetContext) {
        return Padding(
          padding: MediaQuery.of(modalBottomSheetContext).viewInsets,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    TextFormField(
                      controller: _userNameTextEditingController,
                      validator: TextFormFieldValidator.validateMandatory,
                      decoration: InputDecoration(
                        hintText: 'Novo usuário',
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () { 
                          _addUser(context, _userNameTextEditingController.text);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Adicionar'
                        )
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        toolbarHeight: 96,
        title: Text(
          _group == null ? '' : _group.name,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          Center(
            child: Text('Inicial')
          ),
          Builder(
            builder: (BuildContext context) {
              return ListView(
                children: [
                  ListHeader(
                    buttonFunction: _expenseScreen,
                    buttonFunctionParams: {
                      'context': context
                    }
                  ),
                  for (var index = 0; index < _expenses.length; index++)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _expenses[index].name,
                              style: Theme.of(context).textTheme.subtitle1
                            )
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => null
                          )
                        ],
                      )
                    )
                ]
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return ListView(
                children: [
                  ListHeader(
                    buttonFunction: _showUserModalBottomSheet,
                    buttonFunctionParams: {
                      'context': context
                    }
                  ),
                  for (var index = 0; index < _group.users.length; index++)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle, size: 48),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Text(
                              _getUserNameText(_group.users[index]),
                              style: Theme.of(context).textTheme.subtitle1
                            )
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _showDeleteUserDialog(context, _group.users[index].id)
                          )
                        ],
                        )
                    ),
                ],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapButtonNavigation,
        currentIndex: _bottomNavigationCurrentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuários'
          )
        ],
      ),
    );
  }
}
