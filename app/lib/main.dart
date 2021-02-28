import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:http/http.dart' as http;
import 'package:labjobfeature/house/screens/house_route.dart';
import 'package:meta/meta.dart';

void main() {
  final HouseRepository houseRepository = HouseRepository(
    dataProvider: HouseDataProvider(
      httpClient: http.Client(),
    ),
  );

  runApp(DelalaApp(houseRepository: houseRepository));
}

class DelalaApp extends StatelessWidget {
  final HouseRepository houseRepository;
  DelalaApp({@required this.houseRepository}) : assert(houseRepository != null);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: this.houseRepository,
      child: BlocProvider(
        create: (context) =>
            HouseBloc(houseRepository: this.houseRepository)..add(HouseLoad()),
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          title: 'Delala',
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
//        primaryColor: Colors.lightBlue[800],
            primaryColor: Color.fromRGBO(174, 174, 174, 1),
            accentColor: Color.fromRGBO(0, 175, 128, 1),
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
              headline4: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black87),
              bodyText1: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(128 , 127, 127, 1),
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: DelalaAppRoute.generateRoute,
        ),
      ),
    );
  }
}
