import 'package:charts_flutter/flutter.dart' as charts;
import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/formatter/date_format.dart';
import 'package:despesa_app/formatter/money_format.dart';
import 'package:despesa_app/formatter/percentage_format.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/group_user_role.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/expense_repository.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/repository/statistic_repository.dart';
import 'package:despesa_app/screen/expense_screen.dart';
import 'package:despesa_app/screen/user_list_screen.dart';
import 'package:despesa_app/widget/list_header.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  final int id;

  const GroupScreen({Key key, this.id}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  double _totalValue = 0;
  List<Map<String, dynamic>> _statisticValueByUser;
  List<Map<String, dynamic>> _statisticValueByYearMonth;

  Group _group;

  List<Expense> _expenses = [];

  bool _loading = true;

  int _bottomNavigationCurrentIndex = 0;

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
    await _getGroup();
    await _getStatistics();
    await _listExpenses();
  }

  Future<void> _getGroup() async {
    Group get = await GroupRepository.instance.get(widget.id);
    setState(() {
      _group = get;
    });
  }

  Future<void> _getStatistics() async {
    List<Map<String, dynamic>> statisticValueByUserResponse = await StatisticRepository.instance.listValueGroupedByUser(widget.id);
    List<Map<String, dynamic>> statisticValueByYearMonthResponse = await StatisticRepository.instance.listValueGroupedByYearMonth(widget.id);
    setState(() {
      _totalValue = statisticValueByUserResponse.map((statistic) => statistic['value']).reduce((value, element) => value + element);
      _statisticValueByUser = statisticValueByUserResponse;
      _statisticValueByYearMonth = statisticValueByYearMonthResponse;
    });
  }

  Future<void> _listExpenses() async {
    List<Expense> list = await ExpenseRepository.instance.list(widget.id);
    setState(() {
      _expenses = list;
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

  String _getGroupUserRoleText(GroupUserRole groupUserRole) {
    if (groupUserRole == GroupUserRole.OWNER) return "Dono";
    if (groupUserRole == GroupUserRole.ADMIN) return "Administrador";
    return "Usuário";
  }

  Future<void> _deleteExpense(Expense expense) async {
    Map<String, dynamic> deleteResponse = await ExpenseRepository.instance.delete(_group.id, expense.id);
    if (deleteResponse['success']) {
      setState(() {
        _expenses.remove(expense);
      });
    }
  }



  Future<void> _removeUser(int userId) async {
    Group removeUser = await GroupRepository.instance.removeUser(_group.id, userId);
    setState(() {
      _group = removeUser;
    });
  }

  void _showDeleteExpenseDialog(BuildContext context, Expense expense) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir despesa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você quer realmente excluir essa despesa?'),
                Text('Essa ação não pode ser desfeita.'),
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
                _deleteExpense(expense);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddUserModalBottomSheet(Map<String, dynamic> params) {
    BuildContext context = params['context'];

//    _userNameTextEditingController.text = "";

//    showModalBottomSheet<void>(
//      context: context,
//      isScrollControlled: true,
//      builder: (BuildContext modalBottomSheetContext) {
//        return AddUserModalBottomSheet();
//      }
//    );
  }

  void _showRemoveUserDialog(BuildContext context, int userId) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover usuário'),
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

  Future<void> _expenseScreen(Map<String, dynamic> params) async {
    BuildContext context = params['context'];

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseScreen(
          groupId: _group.id,
          expenseId: params['expenseId']
        )
      )
    );

    if (result == null) {
      return;
    }

    if (result) {
      _listExpenses();
    }
  }

  Future<void> _userListScreen(Map<String, dynamic> params) async {
    BuildContext context = params['context'];

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListScreen(
          groupId: _group.id,
        )
      )
    );

    if (result == null) {
      return;
    }

    if (result) {
      _getGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          _group == null ? '' : _group.name,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Divisão dos valores por usuário',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Expanded(
                        child: _statisticValueByUser == null
                          ? Center(child: CircularProgressIndicator())
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: charts.PieChart(
                                      [
                                        charts.Series<Map<String, dynamic>, String>(
                                          id: 'statisticValueByUser',
                                          domainFn: (Map<String, dynamic> statistic, _) => statistic['user'],
                                          measureFn: (Map<String, dynamic> statistic, _) => statistic['value'],
                                          data: _statisticValueByUser,
                                          labelAccessorFn: (Map<String, dynamic> statistic, _) => PercentageFormat.format(statistic['value']/_totalValue * 100),
                                        )
                                      ],
                                      animate: false,
                                      layoutConfig: charts.LayoutConfig(
                                        leftMarginSpec: charts.MarginSpec.fixedPixel(0),
                                        topMarginSpec: charts.MarginSpec.fixedPixel(0),
                                        rightMarginSpec: charts.MarginSpec.fixedPixel(8),
                                        bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
                                      ),
                                      behaviors: [
                                        charts.DatumLegend(
                                          position: charts.BehaviorPosition.top,
                                          outsideJustification: charts.OutsideJustification.startDrawArea,
                                        )
                                      ],
                                      defaultRenderer: charts.ArcRendererConfig(
                                        arcWidth: 60,
                                        arcRendererDecorators: [
                                          charts.ArcLabelDecorator(
                                            labelPosition: charts.ArcLabelPosition.inside
                                          ),
                                        ],
                                      ),
                                  )
                              ),
                            ],
                        )
                      ),
                      SizedBox(
                        height: 16
                      ),
                      Text('Divisão dos valores por mês/ano',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Expanded(
                        child: _statisticValueByYearMonth == null
                        ? Center(child: CircularProgressIndicator())
                        : charts.BarChart(
                            [
                              charts.Series<Map<String, dynamic>, String>(
                                id: 'statisticValueByYearMonth',
                                domainFn: (Map<String, dynamic> statistic, _) => DateFormat.formatYearMonth(statistic['date']),
                                measureFn: (Map<String, dynamic> statistic, _) => statistic['value'],
                                data: _statisticValueByYearMonth,
                              )
                            ],
                            animate: false,
                          ),
                      )
                    ]
                ),
              );
            },
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
                    InkWell(
                      onTap: () => _expenseScreen({'context': context, 'expenseId': _expenses[index].id}),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _expenses[index].name,
                                    style: Theme.of(context).textTheme.headline6
                                  ),
                                  Text(
                                    MoneyFormat.formatCurrency(_expenses[index].value),
                                    style: Theme.of(context).textTheme.subtitle1
                                  ),
                                  Text(
                                    _expenses[index].description ?? 'Sem descrição',
                                    style: Theme.of(context).textTheme.caption
                                  )
                                ],
                              )
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _showDeleteExpenseDialog(context, _expenses[index])
                            )
                          ],
                        )
                      ),
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
                    buttonFunction: _userListScreen,
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
                          CircleAvatar(
                            child: Text(
                              _group.users[index].user.getAcronym(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                              )
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getUserNameText(_group.users[index].user),
                                  style: Theme.of(context).textTheme.headline6
                                ),
                                Text(
                                  _getGroupUserRoleText(_group.users[index].role),
                                  style: Theme.of(context).textTheme.subtitle1
                                ),
                              ],
                            )
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _showRemoveUserDialog(context, _group.users[index].user.id)
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
