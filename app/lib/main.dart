import 'package:delala/bloc_observer.dart';
import 'package:delala/user/bloc/user_bloc.dart';
import 'package:delala/user/bloc/user_event.dart';
import 'package:delala/user/data_provider/user_data.dart';
import 'package:delala/user/repository/user_repository.dart';
import 'package:delala/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() async {
  Bloc.observer = SimpleBlocObserver();

  final UserRepository userRepository = UserRepository(
    dataProvider: UserDataProvider(
      httpClient: http.Client(),
    ),
  );

  runApp(Delala(
    userRepository: userRepository,
  ));
}

class Delala extends StatelessWidget {
  final UserRepository userRepository;

  Delala({@required this.userRepository}) : assert(userRepository != null);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: this.userRepository,
      child: BlocProvider(
        create: (context) =>
            UserBloc(userRepository: this.userRepository)..add(UserView()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Delala',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Color.fromRGBO(174, 174, 174, 1.0),
            accentColor: Color.fromRGBO(0, 175, 128, 1),
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: Color.fromRGBO(0, 175, 128, 1)),
              errorStyle: TextStyle(fontSize: 9, fontFamily: "Segoe UI"),
            ),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: Color.fromRGBO(78, 78, 78, 1),
                contentTextStyle: TextStyle(fontSize: 11)),
            appBarTheme: AppBarTheme(color: Color.fromRGBO(36, 255, 240, 100)),
            tabBarTheme: TabBarTheme(
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: Color.fromRGBO(4, 148, 255, 1),
                labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway"),
                unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway")),
            iconTheme: IconThemeData(color: Color.fromRGBO(120, 120, 120, 1)),
            backgroundColor: Color.fromRGBO(34, 242, 228, 95),
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
                headline3: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                headline4: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                bodyText1: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(128, 127, 127, 1),
                ),
                bodyText2: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    fontFamily: "Segoe UI"),
                subtitle1:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                overline: TextStyle(fontSize: 9),
                // headline5: Theme.of(context)
                //     .textTheme
                //     .headline6
                //     .copyWith(fontSize: 15, fontFamily: "Segoe UI"),
                headline6: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 14, fontFamily: "Segoe UI")),
            buttonTheme: Theme.of(context).buttonTheme.copyWith(
                buttonColor: Color.fromRGBO(4, 148, 255, 1),
                disabledColor: Color.fromRGBO(4, 148, 255, 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Color.fromRGBO(4, 148, 255, 1),
                  primaryVariant: Color.fromRGBO(6, 103, 208, 1),
                  secondary: Color.fromRGBO(209, 87, 17, 1),
                  surface: Color.fromRGBO(120, 120, 120, 1),
                  secondaryVariant: Color.fromRGBO(153, 39, 0, 1),
                ),
          ),
          onGenerateRoute: DelalaAppRoute.generateRoute,
        ),
      ),
    );
  }
}
