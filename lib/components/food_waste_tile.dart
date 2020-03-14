import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/components/dismissible_background.dart';
import 'package:waste_a_gram/constants.dart';

class FoodWasteTile extends StatefulWidget{

  final DocumentSnapshot snapshot;
  final Function onDelete;

  FoodWasteTile({this.snapshot, this.onDelete});

  @override
  _FoodWasteTileState createState() => _FoodWasteTileState();
}

class _FoodWasteTileState extends State<FoodWasteTile> {
  @override
  Widget build(BuildContext context) {
    var post = widget.snapshot;
    return Dismissible(
      background: DismissibleBackground(direction: LEFT_TO_RIGHT, color: Colors.redAccent),
      secondaryBackground: DismissibleBackground(direction: RIGHT_TO_LEFT, color: Colors.redAccent),
      onDismissed: (_) {
        widget.onDelete();
      },
      key: Key(post.hashCode.toString()), 
      child: _FoodWasteItem(
        thumbnail: post[IMAGE_URL],
        description: post[DESCRIPTION],
        quantity: post[QUANTITY],
        weight: post[WEIGHT],
        submissionDate: (post[SUBMISSION_DATE] as Timestamp).toDate(),
      )
    );
  }
}


class _FoodWasteItem extends StatelessWidget {
  const _FoodWasteItem({
    this.thumbnail,
    this.description,
    this.quantity,
    this.weight,
    this.submissionDate,
  });

  final String thumbnail;
  final String description;
  final int quantity;
  final String weight;
  final DateTime submissionDate;

  String monthString(DateTime dateTime){
    switch (dateTime.month) {
      case DateTime.january: return 'January';
      case DateTime.february: return 'February';
      case DateTime.march: return 'March';
      case DateTime.april: return 'April';
      case DateTime.may: return 'May';
      case DateTime.june: return 'June';
      case DateTime.july: return 'July';
      case DateTime.august: return 'August';
      case DateTime.september: return 'September';
      case DateTime.october: return 'October';
      case DateTime.november: return 'November';
      case DateTime.december: return 'December';
      case DateTime.march: return 'March';
        break;
      default: return '';
    } 
  }

  String weekdayToString(DateTime dateTime){
    switch (dateTime.weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return '';
    } 
  }
  

  Widget imageAndQuantity(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/6,
      child: Padding( 
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: FadeInImage.assetNetwork(placeholder: LOADING_GIF, image: thumbnail, fit: BoxFit.cover,))
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(quantity.toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))
                  ), 
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan[200],
        gradient: LinearGradient(colors: [Colors.cyan[200], Colors.white]),
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.white))
      ),
      height: MediaQuery.of(context).size.height/14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('${weekdayToString(submissionDate)}, ${monthString(submissionDate)} ${submissionDate.day}',
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.w700,
                fontSize: 24, 
                fontStyle: FontStyle.italic, 
                shadows: [Shadow(color: Colors.white, offset: Offset(5, 5), blurRadius: 2)]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(quantity.toString(), style: TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.w700))
            ),
          ),
        ],
      )
    );
  }
}
class _FoodWasteData extends StatelessWidget {
  const _FoodWasteData ({
    Key key,
    this.description,
    this.quantity,
    this.weight,
    this.submissionDate,
  }) : super(key: key);

  final String description;
  final int quantity;
  final String weight;
  final DateTime submissionDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$quantity pcs.',
            style: const TextStyle(fontSize: 12.0),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            '${submissionDate.hour}:${submissionDate.minute} ${submissionDate.month}/${submissionDate.day}/${submissionDate.year}',
            style: const TextStyle(fontSize: 12.0),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$weight lbs',
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}