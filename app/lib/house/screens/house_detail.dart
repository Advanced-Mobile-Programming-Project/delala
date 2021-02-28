import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:meta/meta.dart';

class HouseDetail extends StatelessWidget {
  static const routeName = 'houseDetail';
  final House house;

  HouseDetail({@required this.house});

  @override
  Widget build(BuildContext context) {
    var halfWidth = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(house.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
    onPressed: () => Navigator.of(context).pushNamed(
      AddUpdateHouse.routeName,
      arguments: HouseArgument(house: this.house,edit: true),
    ),
          ),
          SizedBox(
            width: 32,
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<HouseBloc>().add(HouseDelete(this.house));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HouseList.routeName, (route) => false);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'images/furniture.jpg',
              height: halfWidth,
              fit: BoxFit.cover,
            ),
            Text(
              house.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              house.category,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              house.status,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              house.description,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
