import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/formatter/date_format.dart';
import 'package:despesa_app/formatter/money_format.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/expense_repository.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/utils/text_form_field_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef bool StepValidate();

class ExpenseScreen extends StatefulWidget {
  final int groupId;
  final int expenseId;

  const ExpenseScreen({
    Key key,
    @required this.groupId,
    this.expenseId
  }) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  Group _group;
  List<User> _users = [];
  Expense _expense;

  bool _loading = true;

  int _currentStep = 0;
  int _firstStep;
  int _lastStep;

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _valueTextEditingController = TextEditingController();
  final TextEditingController _descriptionTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load().then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> _load() async {
    await _getGroup();
    await _getExpense();
  }

  Future<void> _getGroup() async {
    Group get = await GroupRepository.instance.get(widget.groupId);
    setState(() {
      _group = get;
      _users = _group.users.map((groupUserRole) => groupUserRole.user).toList();
    });
  }

  Future<void> _getExpense() async {
    if (widget.expenseId == null) return;

    Expense get = await ExpenseRepository.instance.get(widget.groupId, widget.expenseId);
    setState(() {
      _expense = get;
      _users = _expense.items.map((item) => item.user).toList();

      _nameTextEditingController.value = TextEditingValue(text: _expense.name);
      _valueTextEditingController.value = TextEditingValue(text: _expense.value.toString());
      if (_expense.description != null) {
        _descriptionTextEditingController.value = TextEditingValue(text: _expense.description);
      }
    });
  }

  void _updateUsers(User user, bool selected) {
    setState(() {
      if (selected) {
        _users.add(user);
      } else {
        int index = _users.indexWhere((u) => u.id == user.id);
        _users.removeAt(index);
      }
    });
  }

  String _getTotalValue() {
    if (_valueTextEditingController.text.isEmpty) return "";

    String valueString = _valueTextEditingController.text.replaceAll(",", ".");
    double value = double.parse(valueString);

    return MoneyFormat.formatCurrency(value);
  }

  String _getSplitValue() {
    if (_valueTextEditingController.text.isEmpty) return "";

    String valueString = _valueTextEditingController.text.replaceAll(",", ".");
    double splitValue = double.parse(valueString) / _users.length;

    return MoneyFormat.formatCurrency(splitValue);
  }

  String _getCreatedBy() {
    if (_expense == null) {
      return Authentication.instance.currentUser.fullName;
    }
    return _expense.createdBy.fullName;
  }

  String _getDateCreated() {
    if (_expense == null) {
      return DateFormat.now();
    }
    return DateFormat.format(_expense.dateCreated);
  }

  void _complete(BuildContext context) async {
    String name = _nameTextEditingController.text;
    double value = double.parse(_valueTextEditingController.text);
    String description = _descriptionTextEditingController.text;
    if (description.isEmpty) {
      description = null;
    }

    List<Map<String, dynamic>> items = [];
    double splitValue = value / _users.length;
    for (var user in _users) {
      items.add(
        {
          'value': splitValue,
          'user_id': user.id
        }
      );
    }

    if (_expense == null) {
      await ExpenseRepository.instance.save(_group.id, name, value, description, items);
    } else {
      await ExpenseRepository.instance.update(_group.id, _expense.id, name, value, description, items);
    }

    Navigator.pop(context, true);
  }

  void _close(BuildContext context) {
    Navigator.pop(context, false);
  }

  IconData _getContinueButtonIcon() {
    return _currentStep == _lastStep
        ? Icons.check
        : Icons.arrow_forward;
  }

  void _onStepContinue(BuildContext context) async {
    Function validateFunction = _validateStepList()[_currentStep];
    if (!validateFunction()) return;

    _currentStep == _lastStep
      ? _complete(context)
      : setState(() => _currentStep++);
  }

  bool _onBackPressed(BuildContext context) {
    _currentStep == _firstStep
        ? _close(context)
        : setState(() => _currentStep--);

      return false;
  }

  void _onStepTapped(BuildContext context, int nextStep) {
    Function validateFunction = _validateStepList()[_currentStep];
    if (!validateFunction()) return;

    setState(() => _currentStep = nextStep);
  }

  bool validateExpenseStep() {
    return _formGlobalKey.currentState.validate();
  }

  bool validateUsersStep() {
    return _users.isNotEmpty;
  }

  List<StepValidate> _validateStepList() => [
    validateExpenseStep,
    validateUsersStep,
    () { return true; },
  ];

  List<Step> _steps(BuildContext context) => [
    Step(
      title: Text('Despesa'),
      isActive: _currentStep == 0,
      state: _currentStep == 0
          ? StepState.editing
          : StepState.complete,
      content: Form(
        key: _formGlobalKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameTextEditingController,
              validator: TextFormFieldValidator.validateMandatory,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Despesa',
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _valueTextEditingController,
              validator: TextFormFieldValidator.validateMandatory,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Valor',
                prefix: Text('R\$ '),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _descriptionTextEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Descrição',
              ),
            )
          ],
        )
      )
    ),
    Step(
      title: Text('Divisão'),
      isActive: _currentStep == 1,
      state: _currentStep == 1
          ? StepState.editing
          : _currentStep > 1
            ? StepState.complete
            : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    for (var groupUser in _group.users)
                      ChoiceChip(
                        selected: _users.map((user) => user.id).toList().contains(groupUser.user.id),
                        onSelected: (bool selected) {
                          _updateUsers(groupUser.user, selected);
                        },
                        avatar: CircleAvatar(
                          backgroundColor: groupUser.user.getColor(),
                          child: Text(
                            groupUser.user.getAcronym(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            )
                          ),
                        ),
                        label: Text(groupUser.user.fullName),
                      )
                  ],
                )
              )
            ],
          ),
          _users.isEmpty
              ? Text(
                'Você precisa selecionar pelo menos um usuário',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              )
              : Container(),
          for (var user in _users)
            Container(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.subtitle1
                    )
                  ),
                  Text(
                    _getSplitValue()
                  )
                ],
              )
            ),
          Container(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: Theme.of(context).textTheme.subtitle1
                  )
                ),
                Text(
                  _getTotalValue()
                )
              ],
            )
          ),
        ],
      )
    ),
    Step(
      title: Text('Geral'),
      isActive: _currentStep == 2,
      state: _currentStep == 2
          ? StepState.editing
          : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            initialValue: _getCreatedBy(),
            decoration: InputDecoration(
              labelText: 'Criado por',
            )
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: false,
            initialValue: _getDateCreated(),
            decoration: InputDecoration(
              labelText: 'Data de criação'
            ),
          ),
        ]
      )
    )
  ];

  Widget _getBody(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Step> steps = _steps(context);
    _firstStep = 0;
    _lastStep = steps.length - 1;

    return Row(
      children: [
        Expanded(
          child: Stepper(
            steps: steps,
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (int nextStep) => _onStepTapped(context, nextStep),
            controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
              return SizedBox.shrink();
            },
          )
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text('Nova despesa'),
        ),
        body: _getBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onStepContinue(context),
          child: Icon(_getContinueButtonIcon()),
        ),
      )
    );
  }

}