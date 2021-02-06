import 'package:flutter/material.dart';
import './userHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delala',
//      color: Colors.white,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
//        primaryColor: Colors.lightBlue[800],
        primaryColor: Color.fromRGBO(174, 174, 174, 1),
        accentColor: Color.fromRGBO(0, 175, 128, 1),

        // Define the default font family.
//        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 32.0,
              color: Color.fromRGBO(174, 174, 174, 1),
              fontWeight: FontWeight.w400),
          headline2: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 175, 128, 1),
          ),
          headline3: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black87),
          bodyText1: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(128 , 127, 127, 1),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserHomePage(),
    );
  }
}
