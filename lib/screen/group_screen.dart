import 'package:despesa_app/exception/ApiException.dart';
import 'package:despesa_app/formatter/money_format.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/group_user_role.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_category.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_user.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_year_month.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/screen/expense_screen.dart';
import 'package:despesa_app/screen/group/statistic_value_by_category_pie.dart';
import 'package:despesa_app/screen/group/statistic_value_by_user_pie_chart.dart';
import 'package:despesa_app/screen/group/statistic_value_by_year_month_bar_chart.dart';
import 'package:despesa_app/screen/user_list_screen.dart';
import 'package:despesa_app/screen/user_screen.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:despesa_app/service/expense_service.dart';
import 'package:despesa_app/service/group_service.dart';
import 'package:despesa_app/service/statistic_service.dart';
import 'package:despesa_app/utils/scaffold_utils.dart';
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
  List<StatisticValueGroupedByCategory> _statisticValueByCategory;
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
    List<StatisticValueGroupedByCategory> statisticValueGroupedByCategoryResponse = await StatisticService.instance.listValueGroupedByCategory(_group.id);
    List<StatisticValueGroupedByYearMonth> statisticValueGroupedByYearMonthResponse = await StatisticService.instance.listValueGroupedByYearMonth(_group.id);

    if (statisticValueGroupedByUserResponse.isEmpty && statisticValueGroupedByYearMonthResponse.isEmpty) {
      return;
    }

    setState(() {
      _totalValue = statisticValueGroupedByUserResponse.map((statistic) => statistic.value).reduce((value, element) => value + element);
      _statisticValueByUser = statisticValueGroupedByUserResponse;
      _statisticValueByCategory = statisticValueGroupedByCategoryResponse;
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

  Future<void> _removeUser(int userId, BuildContext context) async {
    try {
      Group removeUser = await GroupService.instance.removeUser(_group.id, userId);
      setState(() {
        _group = removeUser;
      });
    } on ApiException catch (apiException) {
      ScaffoldUtils.showSnackBar(context, apiException.message);
    }
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

  void _showRemoveUserDialog(BuildContext builderContext, int userId) {
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
                _removeUser(userId, builderContext);
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

    return ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.50,
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Divisão dos valores por usuário',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                StatisticValueByUserPieChart(animate: _animateCharts, statisticValueByUser: _statisticValueByUser),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.50,
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Divisão dos valores por categoria',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                StatisticValueByCategoryPieChart(animate: _animateCharts, statisticValueByCategory: _statisticValueByCategory),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.70,
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Divisão dos valores por mês/ano',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                StatisticValueByYearMonthBarChart(animate: _animateCharts, statisticValueByYearMonth: _statisticValueByYearMonth)
              ],
            ),
          ),
        ]
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

  Widget _usersListView(BuildContext builderContext) {
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
                  onPressed: () => _showRemoveUserDialog(builderContext, _group.users[index].user.id)
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
