import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart' as fl;
import 'package:waste_a_gram/models/food_waste_data.dart';
import 'package:waste_a_gram/util/util.dart';

class PostDetailCard extends StatelessWidget{
  
  PostDetailCard({this.post, this.imageStream, this.onTapped});

  final FoodWasteData post;
  final Stream<Uint8List> imageStream;
  final Function onTapped;

  Widget getImage(){
    return StreamBuilder<Uint8List>(
      stream: imageStream,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot){
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        }
        else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
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
        Text(post.description, style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _quantity(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Quantity: ', style: TextStyle(fontSize: 20)),
        Text(post.quantity.toString(), style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _weight(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Weight: ', style: TextStyle(fontSize: 20)),
        Text(post.weight.toString(), style: TextStyle(fontSize: 20),),
      ],
    );
  }

  Widget _submissionDate(){
    final date = post.subissionDate.toDate();
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Text('${weekdayToString(date)}, ${monthString(date)} ${date.day} ${date.year}', style: TextStyle(fontSize: 20),),
    );
  }

  Widget _location(){
    Widget ret;
    final loc = post.location;
    if(loc == null) { 
      ret = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_listed_location),
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

  Widget expandLessIcon() {
    return Align(
      alignment: Alignment.centerRight, 
      child: Container(
        height: 20, 
        child: IconButton(
          icon: Icon(Icons.expand_less), 
          onPressed: onTapped
        )
      )
    );
  }


  Widget detailCard() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          expandLessIcon(),
          Expanded(flex: 1, child: _submissionDate()),
          Expanded(flex: 5, child: getImage()),
          Expanded(flex: 4, child: _details()),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: new Container(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width,
        child: detailCard()
      ),
    );
  }
}