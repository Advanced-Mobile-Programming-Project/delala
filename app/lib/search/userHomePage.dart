import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//header section
    Widget titleSection = Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24,left: 20,right:20),
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
                Text('Find Your New Home',
                    style: Theme.of(context).textTheme.headline2),
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
      margin:EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 20, top: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey[350],
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(5.0, 5.0),)
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
    Container _suggestionBuilder(String imgPath, String label) {
      return Container(
        margin: EdgeInsets.only(right: 20),
        height: 132,
        width: 100,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            height: 122,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[350],
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(5.0, 5.0),)
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
                    height: 100,
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
      padding: EdgeInsets.only(left:20),
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'What are you looking for?',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            height: 152,
            padding: EdgeInsets.only(left:20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    _suggestionBuilder('images/liben.jfif', 'Houses'),
                    _suggestionBuilder('images/liben.jfif', 'Apartments'),
                    _suggestionBuilder('images/liben.jfif', 'Condos')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

//    nearyoubuilder
    Container nearYouBuilder(String imgPath,String item,String city){
      return Container(
        height: 160,
        width: 160,
        margin: EdgeInsets.only(right: 15),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.all(Radius.circular(10.0)),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 12,bottom: 6),
                  child: Text(item,style: Theme.of(context).textTheme.headline4)),
              Row(
                children: [
                  Icon(Icons.location_on,color: Theme.of(context).accentColor,size: 17,),
                  Text(city,style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            ],
          ),
        ),
      );
    }
//nearyousection
    Widget nearYouSection = Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top:30,bottom: 20,left: 20,right: 20),
            child: Row(
              children: [
                Expanded(
                  child:Text('Popular near you',style: Theme.of(context).textTheme.headline3,),
                ),
               Text('view all',style: TextStyle(
                 fontWeight: FontWeight.w500,
                 color: Theme.of(context).accentColor,
               ),)
              ],
            ),
          ),
          Container(
            height: 160,
            padding: EdgeInsets.only(left:20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    nearYouBuilder('images/liben.jfif','Studio Apartment','Los Angeles, CA'),
                    nearYouBuilder('images/liben.jfif','3B Condo','Encino, CA'),
                    nearYouBuilder('images/liben.jfif','2B Condo','Los Angeles, CA'),
                  ],
                ),
              ],
            ),
          ),
        ],
      );



//    recent searches builder
    Container _recentSearchesBuilder(String imgPath,String item,String city) {
      return  Container(
        height: 200,
        width: 200,
        margin: EdgeInsets.only(right: 15),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.all(Radius.circular(10.0)),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 12,bottom: 6),
                  child: Text(item,style: Theme.of(context).textTheme.headline4)),
              Row(
                children: [
                  Icon(Icons.location_on,color: Theme.of(context).accentColor,size: 17,),
                  Text(city,style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            ],
          ),
        ),
      );
    }

//    suggestion section
    Widget _recentSearchesSection = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:20),
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.only(left:20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    _recentSearchesBuilder('images/liben.jfif','Studio Apartment','Los Angeles, CA'),
                    _recentSearchesBuilder('images/liben.jfif','3B Condo','Encino, CA'),
                    _recentSearchesBuilder('images/liben.jfif','2B Condo','Los Angeles, CA')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
        body:ListView(
        children: <Widget>[
          titleSection,
          inputSection,
          suggestionSection,
          nearYouSection,
          _recentSearchesSection
        ],
      ),
    );
  }
}

//Container(
//  margin: EdgeInsets.symmetric(horizontal: 24),
//  child: Column(
//    children: <Widget>[
//      Row(
//        children: <Widget>[
//          Expanded(
//            child: Text('Popular near you'),
//          ),
//          Text('view all')
//        ],
//      ),
//      Container(
//        height: 200,
//        child: ListView(
//          scrollDirection: Axis.horizontal,
//          children: <Widget>[
//            AspectRatio(
//              aspectRatio: 3 / 2,
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    width: 100,
//                    height: 100,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10.0),
//                      image: DecorationImage(
//                          image: AssetImage('images/liben.jpg'),
//                          fit: BoxFit.cover),
//                    ),
//                  ),
//                  Text('Studio Apartment'),
//                  Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.location_on,
//                        color: Colors.green,
//                      ),
//                      Text('6 kilo, Addis Ababa')
//                    ],
//                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      )
//    ],
//  ),
//);
