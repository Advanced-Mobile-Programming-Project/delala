import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:meta/meta.dart';

class HouseDetail extends StatelessWidget {
  static const routeName = 'houseDetail';
  final House house;

  HouseDetail({this.house});

  @override
  Widget build(BuildContext context) {
    Widget _description = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 15),
            child: Text(
              house.description,
              softWrap: true,
              style: TextStyle(
                height: 1.2,
                fontSize: 14.0,
                color: Color.fromRGBO(128, 127, 127, 1),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).accentColor.withAlpha(120),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/bed.svg',
                            width: 26,
                            color: Colors.grey[600],
                          ),
                          Text(
                            '  ${house.bedrooms} Beds',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).accentColor.withAlpha(120),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/bath.svg',
                            width: 26,
                            color: Colors.grey[600],
                          ),
                          Text(
                            ' ${house.bathrooms} Baths',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  '\$${house.cost}',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontSize: 24),
                )),
                ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor,
                  )),
                  child: Container(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        'Schedule a Tour',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );

//  return Scaffold(
//    body: Text("hey"),
//  );
    var halfWidth = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Image.asset(
                  'images/furniture.jpg',
                  height: halfWidth,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
//                      Expanded(
//                        child:
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
//                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AddUpdateHouse.routeName,
                          arguments:
                              HouseArgument(house: this.house, edit: true),
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
                            context
                                .read<HouseBloc>()
                                .add(HouseDelete(this.house));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HouseList.routeName, (route) => false);
                          }),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          house.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              '${house.street}, ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '${house.city}, ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '${house.location}, ',
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: null)
                ],
              ),
            ),
            _description,

//            Text(
//              house.category,
//              style: TextStyle(fontSize: 18),
//            ),
////            Text(
////              house.status,
////              style: TextStyle(fontSize: 18),
////            ),
//            Text(
//              house.description,
//              style: TextStyle(fontSize: 16),
//            )
          ],
        ),
      ),
    );
  }
}
