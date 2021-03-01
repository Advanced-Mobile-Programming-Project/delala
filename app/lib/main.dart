import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:http/http.dart' as http;
import 'package:labjobfeature/house/screens/house_route.dart';
import 'package:labjobfeature/house/screens/user_profile.dart';
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
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: DelalaAppRoute.generateRoute,
          home: App(),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int currentIndex = 0;
  Widget currentScreen = HouseList();
  final PageStorageBucket buket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: buket,
      ),

      floatingActionButton: Container(
        width: 45,
        height: 45,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).pushNamed(
              AddUpdateHouse.routeName,
              arguments: HouseArgument(edit: false),
            ),
            child: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = HouseList();
                    currentIndex = 0;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: currentIndex == 0
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: currentIndex == 0
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.only(right: 10),
                onPressed: () {
                  setState(() {
                    currentScreen = HouseFavotites();
                    currentIndex = 1;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: currentIndex == 1
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Favs',
                      style: TextStyle(
                        color: currentIndex == 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  setState(() {
                    currentScreen = HouseTours();
                    currentIndex = 2;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message,
                      color: currentIndex == 2
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Tour',
                      style: TextStyle(
                        color: currentIndex == 2
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = UserProfile();
                    currentIndex = 3;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message,
                      color: currentIndex == 3
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: currentIndex == 3
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
//        type: BottomNavigationBarType.fixed,
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home_outlined),
//            label: 'Home',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.favorite_border),
//            label: 'Favs',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.message),
//            label: '.',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.pregnant_woman),
//            label: '',
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Theme.of(context).accentColor,
//        onTap: _onItemTapped,
//      ),
    );
  }
}
