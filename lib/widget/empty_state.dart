import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {

  final IconData icon;
  final String title;
  final String description;

  const EmptyState({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              description
            )
          ],
        ),
      )
    );
  }

}