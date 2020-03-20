import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DismissibleBackground extends StatelessWidget{

  final DismissDirection direction;
  final Color color;

  const DismissibleBackground(
    DismissDirection direction, {
    this.color,
  }) : this.direction = direction;

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(color: color),
      child: Row(
        mainAxisAlignment: (direction == DismissDirection.startToEnd) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: (direction == DismissDirection.startToEnd) 
              ? Icon(Icons.delete, color: Colors.white, size: 30,)
              : Container()
          )
        ],
      ),
    );
  }
}