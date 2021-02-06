import 'dart:ui';
import './constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//header section
    Widget titleSection = Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Hello John,',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Text(
                  'Find Your New Home',
                  style: Theme.of(context).textTheme.headline2,
//                  style: TextStyle(
//                      fontSize: 18,
//                      fontWeight: FontWeight.bold,
//                      color: Colors.green[500]),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  'images/liben.jpg',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );

//    input section
    Widget inputSection = Container(
      padding: EdgeInsets.only(left: 20, top: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset(05.0, 10.0))
      ], borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              size: 28.0,
//              color: Theme.of(context).primaryColor,
            ),
            border: InputBorder.none,
            hintText: 'where do you want to live?'),
      ),
    );

    //    suggestion builder function
    Container _suggestionBuilder(String imgPath,String label) {
      return Container(
        margin: EdgeInsets.only(right: 20),
        height: 152,
        width: 120,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            height: 142,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[350],
                      blurRadius: 20.0,
                      offset: Offset(10.0, 10.0))
                ]),
            width: 120,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: Image.asset(
                    imgPath,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyText1,
                    ))
              ],
            ),
          ),
        ),
      );
    }

//    suggestion section
    Widget suggestionSection = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'What are you looking for?',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),

          Container(
            height: 152,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    _suggestionBuilder('images/liben.jfif','Houses'),
                    _suggestionBuilder('images/liben.jfif','Apartments'),
                    _suggestionBuilder('images/liben.jfif','Condos')
                  ],
                ),
              ],
            ),
          ),
//          Row(
//            children: [
//              _suggestionBuilder(),
//              _suggestionBuilder()
//            ],
//          ),

//          Container(
//            height: 200,
//            width: 200,
//            child: Row(
//              children: <Widget>[
//                Container(
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(10.0),
//                      boxShadow: [
//                        BoxShadow(
//                            color: Colors.grey[350],
//                            blurRadius: 20.0,
//                            offset: Offset(0, 10.0))
//                      ]),
//                  child: ClipRRect(
//                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                    child: AspectRatio(
//                      aspectRatio: 2 / 3,
//                      child: Column(
//                        children: <Widget>[
//                          Image.asset(
//                            'images/liben.jpg',
//                            height: 180,
//                            width: 200,
//                            fit: BoxFit.cover,
//                          ),
//                          Text('Houses')
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
        ],
      ),
    );

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          titleSection,
          inputSection,

          suggestionSection,
//        nearYouSection
        ],
      ),
    ));
  }
}

Widget nearYouSection = Container(
  margin: EdgeInsets.symmetric(horizontal: 24),
  child: Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text('Popular near you'),
          ),
          Text('view all')
        ],
      ),
      Container(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: AssetImage('images/liben.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Text('Studio Apartment'),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      Text('6 kilo, Addis Ababa')
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ],
  ),
);
