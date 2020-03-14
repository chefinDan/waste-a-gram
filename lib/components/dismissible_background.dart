import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/constants.dart';

class DismissibleBackground extends StatelessWidget{

  final String direction;
  final Color color;

  const DismissibleBackground({
    this.color,
    this.direction
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(color: Colors.redAccent),
      child: Row(
        mainAxisAlignment: (direction == LEFT_TO_RIGHT) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Icon(Icons.delete, color: Colors.white, size: 30,),
          )
        ],
      ),
    );
  }
}