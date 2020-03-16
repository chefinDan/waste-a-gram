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

final tileDateStyle = TextStyle(
  color: Colors.black, 
    fontWeight: FontWeight.w400,
    fontSize: 20,
);

final tileQuantityStyle = TextStyle(
  color: Colors.deepOrange[400], 
  fontSize: 20, 
  fontWeight: FontWeight.w700
);