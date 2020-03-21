import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/components/custom_text.dart';
import 'package:waste_a_gram/components/dismissible_background.dart';
import 'package:waste_a_gram/models/post.dart';
import 'package:waste_a_gram/util/util.dart';

class FoodWasteTile extends StatefulWidget{

  final Post postData;
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
      confirmDismiss: (direction) => Future.value(direction == DismissDirection.startToEnd),
      background: DismissibleBackground(DismissDirection.startToEnd, color: Colors.redAccent),
      secondaryBackground: DismissibleBackground(DismissDirection.endToStart, color: Colors.grey),
      onDismissed: (_) {
        widget.onDelete();
      },
      key: Key(widget.postData.hashCode.toString()), 
      child: _MinimizedCard(
        imageUrl: widget.postData.imageUrl,
        description: widget.postData.description,
        quantity: widget.postData.quantity,
        weight: widget.postData.weight,
        submissionDate: widget.postData.submissionDate.toDate(),
        postLocation: widget.postData.location,
        onTapped: widget.onTapped
      )
    );
  }
}


class _MinimizedCard extends StatelessWidget {
  const _MinimizedCard({
    this.imageUrl,
    this.description,
    this.quantity,
    this.weight,
    this.submissionDate,
    this.postLocation,
    this.onTapped,
  });

  final String imageUrl;
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
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              '${weekdayToString(submissionDate)}, ${monthString(submissionDate)} ${submissionDate.day}',
              style: tileDateStyle
            ),
          ),
          (imageUrl == null) ? CircularProgressIndicator(): emptyWidget,
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  quantity.toString(), 
                  style: tileQuantityStyle
                ),
                IconButton(icon: Icon(Icons.expand_more), onPressed: null)
              ] 
            )
          ),
        ],
      )
    );
  }
}