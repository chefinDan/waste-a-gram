import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/util/util.dart';

class PostDetailCard extends StatelessWidget{
  
  final DocumentSnapshot post;

  PostDetailCard({this.post});

  Widget _image(){
    Widget ret;
    final img = post[IMAGE_URL];
    if(img == null){
      ret = LayoutBuilder(
        builder: (context, constraints){
          return Center(
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, size: constraints.maxWidth/8,))
          );
        }  
      );
    }
    else{
      ret = Image.network(
        post[IMAGE_URL],
        frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          if(frame == null)
            return Center(child: CircularProgressIndicator());

          return AnimatedOpacity(
            child: child,
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
          );
        }, 
        alignment: Alignment.topLeft,
        fit: BoxFit.contain
      );
    }
    return ret;
  }

  Widget _details(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _description(),
        _quantity(),
        _weight(),
        _location()
      ],
    );
  }

  Widget _description(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(post[DESCRIPTION], style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _quantity(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Quantity: ', style: TextStyle(fontSize: 20)),
        Text(post[QUANTITY].toString(), style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _weight(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Weight: ', style: TextStyle(fontSize: 20)),
        Text(post[WEIGHT].toString(), style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _submissionDate(){
    final date = post[SUBMISSION_DATE].toDate();
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Text('${weekdayToString(date)}, ${monthString(date)} ${date.day} ${date.year}', style: TextStyle(fontSize: 20),),
    );
  }

  Widget _location(){
    Widget ret;
    final loc = post[POST_LOCATION];
    if(loc == null) { 
      ret = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_listed_location),
          // Text(loc.toString())
        ],
      );
    }
    else{
      ret = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on),
          Text('${loc.latitude}, ${loc.longitude}')
        ]
      ); 
    }
    return ret;
  }

  Widget detailCard() {
    return Card(
      color: Colors.white,
      elevation: 10.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 1, child: _submissionDate()),
          Expanded(flex: 5, child: _image()),
          Expanded(flex: 4, child: _details())
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          color: Colors.black45,
          alignment: Alignment.centerLeft,
          padding: new EdgeInsets.only(
            right: 20.0,
            left: 20.0
          ),
          child: GestureDetector(
            onTap: (){},
            child: new Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child: detailCard()
            ),
          )
        ),
    );
  }
}