import 'package:flutter/material.dart';

class AddPostButton extends StatelessWidget{

  const AddPostButton({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 2,
      backgroundColor: Colors.deepOrange[300],
      splashColor: Colors.white,
      onPressed: onPressed,
      child: Icon(Icons.add),
    );
  }

} 


