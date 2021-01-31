import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/expense_repository.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/utils/money_utils.dart';
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
      _users = _group.users.toList();
    });
  }

  Future<void> _getExpense() async {
    if (widget.expenseId == null) return;

    Expense get = await ExpenseRepository.instance.get(widget.expenseId);
    setState(() {
      _expense = get;

      List<int> usersId = _expense.items.map((item) => item.userId).toList();
      _users = _group.users.where((user) => usersId.contains(user.id)).toList();

      _nameTextEditingController.value = TextEditingValue(text: _expense.name);
      _valueTextEditingController.value = TextEditingValue(text: _expense.value.toString());
      _descriptionTextEditingController.value = TextEditingValue(text: _expense.description);
    });
  }

  void _updateUsers(User user, bool selected) {
    setState(() {
      if (selected) {
        _users.add(user);
      } else {
        _users.remove(user);
      }
    });
  }

  String _getTotalValue() {
    if (_valueTextEditingController.text.isEmpty) return "";

    String valueString = _valueTextEditingController.text.replaceAll(",", ".");
    double value = double.parse(valueString);

    return MoneyUtils.formatCurrency(value);
  }

  String _getSplitValue() {
    if (_valueTextEditingController.text.isEmpty) return "";

    String valueString = _valueTextEditingController.text.replaceAll(",", ".");
    double splitValue = double.parse(valueString) / _users.length;

    return MoneyUtils.formatCurrency(splitValue);
  }

  void _complete(BuildContext context) async {
    String name = _nameTextEditingController.text;
    double value = double.parse(_valueTextEditingController.text);
    String description = _descriptionTextEditingController.text;

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
      await ExpenseRepository.instance.update(_expense.id, name, value, description, items);
    }

    Navigator.pop(context, true);
  }

  void _close(BuildContext context) {
    Navigator.pop(context, false);
  }

  String _getContinueButtonText() {
    return _currentStep == _lastStep
        ? "CONCLUIR"
        : "AVANÇAR";
  }

  String _getCancelButtonText() {
    return _currentStep == _firstStep
        ? "CANCELAR"
        : "VOLTAR";
  }

  void _onStepContinue(BuildContext context) async {
    Function validateFunction = _validateStepList()[_currentStep];
    if (!validateFunction()) return;

    _currentStep == _lastStep
      ? _complete(context)
      : setState(() => _currentStep++);
  }

  void _onStepCancel(BuildContext context) {
    _currentStep == _firstStep
        ? _close(context)
        : setState(() => _currentStep--);
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
                labelText: 'Despesa'
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
              validator: TextFormFieldValidator.validateMandatory,
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
                    for (var user in _group.users)
                      ChoiceChip(
                        selected: _users.contains(user),
                        onSelected: (bool selected) {
                          _updateUsers(user, selected);
                        },
                        avatar: CircleAvatar(
                          child: Icon(Icons.account_circle),
                        ),
                        label: Text(user.fullName),
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
      title: Text('Arquivos'),
      isActive: _currentStep == 2,
      state: _currentStep == 2
          ? StepState.editing
          : StepState.indexed,
      content: Text('Pitch black malt barleywine specific gravity wort chiller balthazar pitch.')
    )
  ];

  Widget _getBody(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
              onStepContinue: () => _onStepContinue(context),
              onStepCancel: () => _onStepCancel(context),
              controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                return Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        onPressed: onStepCancel,
                        child: Text(
                          _getCancelButtonText()
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      RaisedButton(
                        onPressed: onStepContinue,
                        child: Text(
                          _getContinueButtonText()
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ),
        ]
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('Nova despesa'),
      ),
      body: _getBody(context)
    );
  }

}