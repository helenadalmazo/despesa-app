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

  Group _group;

  bool _loading = true;

  int _bottomNavigationCurrentIndex = 0;

  PageController _pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();

    _getGroup();

    setState(() {
      _loading = false;
    });
  }

  void _getGroup() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 32,
                right: 32,
                bottom: 16,
                left: 32
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
              child: Text(
                  _group == null ? '' : _group.name,
                style: Theme.of(context).textTheme.headline5
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: <Widget>[
                  Center(
                    child: Text('Inicial')
                  ),
                  Center(
                    child: Text('Despesas')
                  ),
                  Center(
                    child: Text('Usuários')
                  ),
                ],
              )
            )
          ],
        ),
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
