import 'package:flutter/material.dart';

class FoodWasteItem extends StatelessWidget {
  const FoodWasteItem({
    this.thumbnail,
    this.description,
    this.weight,
    this.submissionDate,
  });

  final String thumbnail;
  final String description;
  final String weight;
  final DateTime submissionDate;
  @override
  Widget build(BuildContext context) {
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
                child: FadeInImage.assetNetwork(placeholder: 'lib/assets/loading.gif', image: thumbnail, fit: BoxFit.cover,))
            ),
            Expanded(
              flex: 3,
              child: _FoodWasteData(
                description: description,
                weight: weight,
                submissionDate: submissionDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodWasteData extends StatelessWidget {
  const _FoodWasteData ({
    Key key,
    this.description,
    this.weight,
    this.submissionDate,
  }) : super(key: key);

  final String description;
  final String weight;
  final DateTime submissionDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            '${submissionDate.hour}:${submissionDate.minute} ${submissionDate.month}/${submissionDate.day}/${submissionDate.year}',
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$weight lbs',
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}