
import 'package:despesa_app/model/group_model.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  final int id;

  const GroupScreen({Key key, this.id}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  Group group;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getGroup();

    setState(() {
      loading = false;
    });
  }

  void getGroup() async {
    Group get = await GroupRepository.instance.get(widget.id);
    setState(() {
      group = get;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          group != null ? group.name : ''
        )
      )
    );
  }
}
