import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/components/custom_text.dart';
import 'package:waste_a_gram/components/dismissible_background.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/util/util.dart';

class FoodWasteTile extends StatefulWidget{

  final DocumentSnapshot postData;
  final Function onDelete;
  final Function onTapped;

  FoodWasteTile({this.postData, this.onDelete, this.onTapped});

  @override
  _FoodWasteTileState createState() => _FoodWasteTileState();
}

class _FoodWasteTileState extends State<FoodWasteTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: DismissibleBackground(direction: LEFT_TO_RIGHT, color: Colors.redAccent),
      secondaryBackground: DismissibleBackground(direction: RIGHT_TO_LEFT, color: Colors.redAccent),
      onDismissed: (_) {
        widget.onDelete();
      },
      key: Key(widget.postData.hashCode.toString()), 
      child: _FoodWasteData(
        thumbnail: widget.postData[IMAGE_URL],
        description: widget.postData[DESCRIPTION],
        quantity: widget.postData[QUANTITY],
        weight: widget.postData[WEIGHT],
        submissionDate: (widget.postData[SUBMISSION_DATE] as Timestamp).toDate(),
        postLocation: widget.postData[POST_LOCATION],
        onTapped: widget.onTapped
      )
    );
  }
}


class _FoodWasteData extends StatelessWidget {
  const _FoodWasteData({
    this.thumbnail,
    this.description,
    this.quantity,
    this.weight,
    this.submissionDate,
    this.postLocation,
    this.onTapped,
  });

  final String thumbnail;
  final String description;
  final int quantity;
  final String weight;
  final DateTime submissionDate;
  final GeoPoint postLocation;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.deepOrange[200],
        onTap: onTapped,
        child: cardBody(context) 
      )
    );
  }

  Widget cardBody(BuildContext context){
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height/14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              '${weekdayToString(submissionDate)}, ${monthString(submissionDate)} ${submissionDate.day}',
              style: tileDateStyle
            ),
          ),
          (thumbnail == null) ? CircularProgressIndicator(): Container(),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                quantity.toString(), 
                style: tileQuantityStyle
              )
            ),
          ),
        ],
      )
    );
  }
}