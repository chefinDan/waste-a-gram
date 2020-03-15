import 'package:flutter/material.dart';

Widget appBarTitle(String title) { 
  return Text(
    title, 
    style: TextStyle(
      shadows: [
        // Shadow(
        //   color: Colors.deepOrange[500], 
        //   offset: Offset(2, 2)
        // )
      ],
      fontSize: 24
    ),
  );
}