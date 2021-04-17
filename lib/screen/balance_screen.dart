import 'package:despesa_app/formatter/money_format.dart';
import 'package:despesa_app/model/balance.dart';
import 'package:despesa_app/model/split.dart';
import 'package:despesa_app/model/statement.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/screen/expense_screen.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:despesa_app/service/expense_service.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  final int groupId;
  final int year;
  final int month;

  const BalanceScreen({
    Key key,
    @required this.groupId,
    @required this.year,
    @required this.month,
  }) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {

  final User _currentUser = AuthenticationService.currentUser;
  Balance _balance;

  @override
  void initState() {
    super.initState();

    _getBalance();
  }

  Future<void> _getBalance() async {
    Balance response = await ExpenseService.instance.balance(widget.groupId, widget.year, widget.month);
    setState(() {
      _balance = response;
    });
  }

  void _expenseScreen(BuildContext context, int expenseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ExpenseScreen(
          groupId: widget.groupId,
          expenseId: expenseId
        )
      )
    );
  }

  Widget _getBody() {
    if (_balance == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_balance.balance == null) {
      return Center(
        child: Text(
          "Nenhum resultado para exibir"
        ),
      );
    }

    return ListView.separated(
      itemCount: _balance.statement.length,
      itemBuilder: (BuildContext context, int index) {
        Statement statement = _balance.statement[index];

        return InkWell(
          onTap: () => _expenseScreen(context, statement.expenseId),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    statement.name,
                    style: Theme.of(context).textTheme.subtitle1
                  )
                ),
                Text(
                  MoneyFormat.formatCurrency(statement.value),
                  style: Theme.of(context).textTheme.subtitle2.merge(
                    TextStyle(
                      color: statement.value > 0 ? Colors.lightGreen : Colors.red
                    )
                  )
                ),
              ],
            )
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget _getFooter(BuildContext context) {
    if (_balance == null || _balance.balance == null) {
      return SizedBox.shrink();
    }

    Widget balanceWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "SALDO",
            style: Theme.of(context).textTheme.headline6
          )
        ),
      Text(
        MoneyFormat.formatCurrency(_balance.balance),
        style: Theme.of(context).textTheme.headline6.merge(
          TextStyle(
            color: _balance.balance > 0 ? Colors.lightGreen : Colors.red
          )
        )
      ),
      ],
    );

    List<Widget> splitWidget = [];
    for (Split split in _balance.split) {
      bool receiver;
      String payerText;
      String receiverText;

      if (_currentUser.id == split.payer.id) {
        receiver = false;
        payerText = "Você deve ";
        receiverText = " para ${split.receiver.fullName}";
      } else {
        receiver = true;
        payerText = "${split.payer.fullName} deve ";
        receiverText = " a você";
      }

      Widget richText = RichText(
        text: TextSpan(
          text: payerText,
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: MoneyFormat.formatCurrency(split.value),
              style: TextStyle(
                color: receiver ? Colors.lightGreen : Colors.red
              )
            ),
            TextSpan(
              text: receiverText
            ),
          ],
        ),
      );
      splitWidget.add(richText);
      splitWidget.add(
        SizedBox(
          height: 24
        )
      );
    }

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          balanceWidget,
          SizedBox(
            height: 24
          ),
          ...splitWidget,
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor
        ),
        title: Text(
          "Saldo e extrato",
          style: Theme.of(context).textTheme.headline6.merge(
            TextStyle(
              color: Theme.of(context).primaryColor
            )
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _getBody()
          ),
          _getFooter(context)
        ],
      ),
    );
  }
}
