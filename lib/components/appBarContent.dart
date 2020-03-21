import 'package:flutter/material.dart';
import 'package:waste_a_gram/components/custom_text.dart';
import 'package:waste_a_gram/util/util.dart';

class AppBarTitle extends StatelessWidget{

  const AppBarTitle({this.title, this.foodWasteTotal});

  final String title;
  final int foodWasteTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
          appBarTitle(title),
          Text((foodWasteTotal == null) ? '0' : foodWasteTotal.toString()),
        ]
      ),
    );
  }
}

class AppBarActions extends StatelessWidget{ 

  final ActionType actionType;

  AppBarActions.sort() : actionType = ActionType.sort;

  @override
  Widget build(BuildContext context) {
    switch (actionType) {
      case ActionType.sort:
        return IconButton(
          icon: Icon(Icons.sort),
          tooltip: 'Sort Posts',
          onPressed: (){},
        );
      default:
        return emptyWidget;
    }
  }
}

enum ActionType {
  sort
}