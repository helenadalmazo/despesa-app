import 'package:charts_flutter/flutter.dart' as charts;
import 'package:despesa_app/formatter/date_format.dart';
import 'package:despesa_app/formatter/money_format.dart';
import 'package:despesa_app/formatter/percentage_format.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/group_user_role.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_user.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_year_month.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/screen/expense_screen.dart';
import 'package:despesa_app/screen/user_list_screen.dart';
import 'package:despesa_app/screen/user_screen.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:despesa_app/service/expense_service.dart';
import 'package:despesa_app/service/group_service.dart';
import 'package:despesa_app/service/statistic_service.dart';
import 'package:despesa_app/widget/empty_state.dart';
import 'package:despesa_app/widget/list_header.dart';
import 'package:despesa_app/widget/user_circle_avatar.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({
    Key key,
    this.group
  }) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  double _totalValue = 0;
  List<StatisticValueGroupedByUser> _statisticValueByUser;
  List<StatisticValueGroupedByYearMonth> _statisticValueByYearMonth;

  bool _animateCharts = true;

  Group _group;

  List<Expense> _expenses;

  bool _loading = true;

  int _bottomNavigationCurrentIndex = 0;

  final PageController _pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _load().then((_) {
      setState(() {
        _loading = true;
      });
    });
  }

  Future<void> _load() async {
    await _getGroup();
    await _getStatistics();
    await _getExpenses();
  }

  Future<void> _getGroup() async {
    Group response = await GroupService.instance.get(_group.id);
    setState(() {
      _group = response;
    });
  }

  Future<void> _getStatistics() async {
    List<StatisticValueGroupedByUser> statisticValueGroupedByUserResponse = await StatisticService.instance.listValueGroupedByUser(_group.id);
    List<StatisticValueGroupedByYearMonth> statisticValueGroupedByYearMonthResponse = await StatisticService.instance.listValueGroupedByYearMonth(_group.id);

    if (statisticValueGroupedByUserResponse.isEmpty && statisticValueGroupedByYearMonthResponse.isEmpty) {
      return;
    }

    setState(() {
      _totalValue = statisticValueGroupedByUserResponse.map((statistic) => statistic.value).reduce((value, element) => value + element);
      _statisticValueByUser = statisticValueGroupedByUserResponse;
      _statisticValueByYearMonth = statisticValueGroupedByYearMonthResponse;
    });
  }

  Future<void> _getExpenses() async {
    List<Expense> response = await ExpenseService.instance.list(_group.id);
    setState(() {
      _expenses = response;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _animateCharts = false;
      _bottomNavigationCurrentIndex = index;
    });
  }

  void _onTapButtonNavigation(int index) {
    setState(() {
      _animateCharts = false;
      _bottomNavigationCurrentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease
      );
    });
  }

  String _getUserNameText(User user) {
    bool isCurrentUser = AuthenticationService.currentUser.username == user.username;
    return '${user.fullName} ${isCurrentUser ? '(Você)' : ''}';
  }

  String _getGroupUserRoleText(GroupUserRole groupUserRole) {
    if (groupUserRole == GroupUserRole.OWNER) return "Dono";
    if (groupUserRole == GroupUserRole.ADMIN) return "Administrador";
    return "Usuário";
  }

  Future<void> _deleteExpense(Expense expense) async {
    bool deleteResponse = await ExpenseService.instance.delete(_group.id, expense.id);
    if (deleteResponse) {
      setState(() {
        _expenses.remove(expense);
      });
    }
  }

  Future<void> _removeUser(int userId) async {
    Group removeUser = await GroupService.instance.removeUser(_group.id, userId);
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
        fullscreenDialog: true,
        builder: (context) => ExpenseScreen(
          groupId: _group.id,
          expenseId: params['expenseId']
        )
      )
    );

    if (result) {
      _getExpenses();
    }
  }

  Future<void> _userScreen(BuildContext context, User user) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(
            group: _group,
            user: user
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

  Future<void> _userListScreen(Map<String, dynamic> params) async {
    BuildContext context = params['context'];

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => UserListScreen(
          group: _group,
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

  Widget _homePageView(BuildContext context) {
    if (_totalValue == 0) {
      return EmptyState(
        icon: Icons.dashboard,
        title: "Resumo",
        description: "Aqui você vai visualizar a divisão dos valores do grupo por usuário e por mês/ano.",
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Divisão dos valores por usuário',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Expanded(
            child: _statisticValueByUser == null
              ? Center(child: CircularProgressIndicator())
              : charts.PieChart(
              [
                charts.Series<StatisticValueGroupedByUser, String>(
                  id: 'statisticValueByUser',
                  domainFn: (StatisticValueGroupedByUser statistic, _) => statistic.user.getFirstName(),
                  measureFn: (StatisticValueGroupedByUser statistic, _) => statistic.value,
                  colorFn: (StatisticValueGroupedByUser statistic, _) {
                    Color color = statistic.user.getColor();
                    return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
                  },
                  data: _statisticValueByUser,
                  labelAccessorFn: (StatisticValueGroupedByUser statistic, _) => PercentageFormat.format(statistic.value/_totalValue * 100),
                )
              ],
              animate: _animateCharts,
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
                  desiredMaxRows: 2,
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
          SizedBox(
              height: 16
          ),
          Text('Divisão dos valores por mês/ano',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Expanded(
            child: _statisticValueByYearMonth == null
              ? Center(child: CircularProgressIndicator())
              : charts.BarChart(
              [
                charts.Series<StatisticValueGroupedByYearMonth, String>(
                  id: 'statisticValueByYearMonth',
                  domainFn: (StatisticValueGroupedByYearMonth statistic, _) => DateFormat.formatYearMonth(statistic.date),
                  measureFn: (StatisticValueGroupedByYearMonth statistic, _) => statistic.value,
                  colorFn: (StatisticValueGroupedByYearMonth statistic, _) {
                    Color color = Theme.of(context).primaryColorLight;
                    return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
                  },
                  data: _statisticValueByYearMonth,
                )
              ],
              animate: _animateCharts,
            ),
          )
        ]
      ),
    );
  }

  Widget _expensesListView(BuildContext context) {
    if (_expenses == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_expenses.isEmpty) {
      return EmptyState(
        icon: Icons.attach_money,
        title: "Despesas",
        description: "Aqui você vai visualizar as depesas do grupo, para começar clique no botão acima.",
      );
    }

    return ListView.separated(
      itemCount: _expenses.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
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
                        style: Theme.of(context).textTheme.subtitle1
                      ),
                      Text(
                        MoneyFormat.formatCurrency(_expenses[index].value),
                      ),
                      Text(
                        _expenses[index].description ?? 'Sem descrição',
                        style: Theme.of(context).textTheme.caption
                      )
                    ],
                  )
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteExpenseDialog(context, _expenses[index])
                )
              ],
            )
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget _usersListView(BuildContext context) {
    return ListView.separated(
      itemCount: _group.users.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => _userScreen(context, _group.users[index].user),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16
            ),
            child: Row(
              children: [
                Hero(
                  tag: "user_avatar_${_group.users[index].user.id}",
                  child: UserCircleAvatar(
                    user: _group.users[index].user
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: "user_fullName_${_group.users[index].user.id}",
                        child: Text(
                          _getUserNameText(_group.users[index].user),
                          style: Theme.of(context).textTheme.subtitle1
                        ),
                      ),
                      Text(
                        _getGroupUserRoleText(_group.users[index].role),
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
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          _group.name
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return _homePageView(context);
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  ListHeader(
                    buttonFunction: _expenseScreen,
                    buttonFunctionParams: {
                      'context': context
                    }
                  ),
                  Expanded(
                    child: _expensesListView(context)
                  )
                ]
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  ListHeader(
                    buttonFunction: _userListScreen,
                    buttonFunctionParams: {
                      'context': context
                    }
                  ),
                  Expanded(
                    child: _usersListView(context),
                  )
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
            icon: Icon(Icons.dashboard),
            label: 'Resumo',
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
