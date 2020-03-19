import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart' as fl;
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/util/util.dart';

class PostDetailCard extends StatelessWidget{
  
  PostDetailCard({this.post, this.imageStream});

  final DocumentSnapshot post;
  Stream<Uint8List> imageStream;

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

  Widget _image(){
    return Image(
      frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        if(frame == null){
          return Center(child: CircularProgressIndicator());
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      },
      image: fl.NetworkImageWithRetry(
        post[IMAGE_URL],
        fetchStrategy: (uri, failure) {
          if(failure == null){
            return Future.value(
              fl.FetchInstructions.attempt(
                uri: uri, 
                timeout: Duration(seconds: 5)
              )
            );
          }
          if(failure?.attemptCount < 3){
            return Future.delayed(Duration(seconds: 1))
              .then((_) => fl.FetchInstructions
                .attempt(
                  uri: uri,
                  timeout: Duration(seconds: 5)
                )
              );    
          }
          else{
            return Future.value(fl.FetchInstructions.giveUp(uri: uri));
          }
        }
      )
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
          Expanded(flex: 5, child: getImage()),
          Expanded(flex: 4, child: _details()),
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