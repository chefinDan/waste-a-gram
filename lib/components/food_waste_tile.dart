import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/components/custom_text.dart';
import 'package:waste_a_gram/components/dismissible_background.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/util/util.dart';

class FoodWasteTile extends StatefulWidget{

  final DocumentSnapshot snapshot;
  final Function onDelete;
  final Function onTapped;

  FoodWasteTile({this.snapshot, this.onDelete, this.onTapped});

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
        postLocation: post[POST_LOCATION],
        onTapped: widget.onTapped
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