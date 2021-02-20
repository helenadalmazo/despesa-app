import 'package:despesa_app/clipper/isosceles_trapezoid_clipper.dart';
import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final Function buttonFunction;
  final Map<String, dynamic> buttonFunctionParams;

  const ListHeader({Key key, this.buttonFunction, this.buttonFunctionParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: IsoscelesTrapezoidClipper(),
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: FloatingActionButton(
                onPressed: () => buttonFunction(buttonFunctionParams),
                child: Icon(
                  Icons.add
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}