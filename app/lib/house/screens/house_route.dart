import 'package:flutter/material.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:labjobfeature/house/screens/house_add_update.dart';

class DelalaAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => HouseList());
    }

    if (settings.name == AddUpdateHouse.routeName) {
      HouseArgument args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => AddUpdateHouse(
            args: args,
          ));
    }


    if (settings.name == HouseDetail.routeName) {
      House house = settings.arguments;
      return MaterialPageRoute(builder: (context) => HouseDetail(house: house));
    }
    return MaterialPageRoute(builder: (context) => HouseList());
  }
}

class HouseArgument {
  final House house;
  final bool edit;

  HouseArgument({this.house, this.edit});
}
