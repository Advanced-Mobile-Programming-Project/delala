import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:labjobfeature/house/bloc/bloc.dart';
import 'package:labjobfeature/house/house.dart';

class HouseList extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    //header section
    Widget titleSection = Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 20, top: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          spreadRadius: 2.0,
          offset: Offset(5.0, 5.0),
        )
      ], borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: TextField(
        cursorColor: Theme.of(context).accentColor,
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
                    offset: Offset(5.0, 5.0),
                  )
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
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'What are you looking for?',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            height: 152,
            padding: EdgeInsets.only(left: 20),
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
    Container nearYouBuilder(String imgPath, String item, String city) {
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 12, bottom: 6),
                  child:
                      Text(item, style: Theme.of(context).textTheme.headline4)),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).accentColor,
                    size: 17,
                  ),
                  Text(city, style: Theme.of(context).textTheme.bodyText1)
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
          padding:
              const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Popular near you',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Text(
                'view all',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 160,
          padding: EdgeInsets.only(left: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  nearYouBuilder('images/liben.jfif', 'Studio Apartment',
                      'Los Angeles, CA'),
                  nearYouBuilder('images/liben.jfif', '3B Condo', 'Encino, CA'),
                  nearYouBuilder(
                      'images/liben.jfif', '2B Condo', 'Los Angeles, CA'),
                ],
              ),
            ],
          ),
        ),
      ],
    );

//    recent searches builder
    Container _recentSearchesBuilder(String imgPath, String item, String city) {
      return Container(
        height: 200,
        width: 200,
        margin: EdgeInsets.only(right: 15),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 12, bottom: 6),
                  child:
                      Text(item, style: Theme.of(context).textTheme.headline4)),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).accentColor,
                    size: 17,
                  ),
                  Text(city, style: Theme.of(context).textTheme.bodyText1)
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
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.only(left: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    _recentSearchesBuilder('images/liben.jfif',
                        'Studio Apartment', 'Los Angeles, CA'),
                    _recentSearchesBuilder(
                        'images/liben.jfif', '3B Condo', 'Encino, CA'),
                    _recentSearchesBuilder(
                        'images/liben.jfif', '2B Condo', 'Los Angeles, CA')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

//    //    house item  builder
//    Container _houseBuilder(String imgPath, String item, String city, context) {
////      double addressWidth = 200;
////      double mortgageWidth = 100;
//      return Container(
//        padding: EdgeInsets.symmetric(horizontal: 20),
//        margin: EdgeInsets.only(bottom: 20, top: 20),
//        child: Column(
//          children: [
//            ClipRRect(
//              borderRadius: BorderRadius.all(Radius.circular(10.0)),
//              child: Image.asset(
//                imgPath,
//                height: 200,
//                width: double.infinity,
//                fit: BoxFit.cover,
//              ),
//            ),
//            Container(
//              padding: EdgeInsets.only(top: 15),
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Container(
//                        padding: EdgeInsets.only(bottom: 2),
////                        width: addressWidth,
//                        child: Flexible(
//                          child: Text(
//                            'Victoria Apartments',
//                            style: Theme.of(context).textTheme.headline3,
//                          ),
//                        ),
//                      ),
//                      Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          Padding(
//                            padding: EdgeInsets.only(right: 8),
//                            child: Row(
//                              children: [
//                                SvgPicture.asset(
//                                  'images/bed.svg',
//                                  width: 26,
//                                  color: Colors.grey[600],
//                                ),
//                                Padding(
//                                    padding: EdgeInsets.only(left: 5),
//                                    child: Text(
//                                      '3 Beds',
//                                      style:
//                                          Theme.of(context).textTheme.bodyText1,
//                                    )),
//                              ],
//                            ),
//                          ),
//                          Row(
//                            children: [
//                              SvgPicture.asset(
//                                'images/bath.svg',
//                                width: 26,
//                                color: Colors.grey[600],
//                              ),
//                              Padding(
//                                  padding: EdgeInsets.only(left: 5),
//                                  child: Text(
//                                    '2 Baths',
//                                    style:
//                                        Theme.of(context).textTheme.bodyText1,
//                                  )),
//                            ],
//                          )
//                        ],
//                      ),
//                      Container(
//                          padding: EdgeInsets.only(top: 5),
////                          width: addressWidth,
//                          child: Flexible(
//                              child: Text(
//                            '3rd st,Los Angeles, CA 90036',
//                            style: Theme.of(context).textTheme.bodyText1,
//                          )))
//                    ],
//                  ),
//                  Spacer(),
//                  Column(
//                    children: [
//                      Center(
//                        child: Text(
//                          '\$8,948',
//                          style: TextStyle(
//                              fontSize: 25,
//                              color: Theme.of(context).accentColor,
//                              fontWeight: FontWeight.bold),
//                        ),
//                      ),
////                      Container(
////                        child: Flexible(
////                          child:
//
////                        ),
////                      ),
////                      Container(
//////                          width: mortgageWidth,
////                          child: Column(
////                            children: [
////                              Flexible(
////                                  child: Text(
////                                'Est. Mortgage \$113/mo',
////                                style: Theme.of(context).textTheme.bodyText1,
////                              )),
////                              Flexible(
////                                  child: Text(
////                                '\$113/mo',
////                                style: Theme.of(context).textTheme.bodyText1,
////                              )),
////                            ],
////                          )),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      );
//    }

    ListView _houseBuilder(houses) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
//        physics: ScrollPhysics(),
        itemCount: houses.length,
        itemBuilder: (_, idx) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, HouseDetail.routeName,
              arguments: houses[idx]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.asset(
                    'images/liben.jfif',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 2),
                            width: 180,
                            child: Flexible(
                              child: Text(
                                '${houses[idx].title}',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'images/bed.svg',
                                      width: 26,
                                      color: Colors.grey[600],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '${houses[idx].bedrooms} Beds',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'images/bath.svg',
                                    width: 26,
                                    color: Colors.grey[600],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        '${houses[idx].bathrooms} Baths',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                ],
                              )
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Flexible(
                                  child: Text(
                                '${houses[idx].street}, ${houses[idx].city}, ${houses[idx].location}',
                                style: Theme.of(context).textTheme.bodyText1,
                              )))
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              '\$${houses[idx].cost}',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//          Row(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Expanded(
//                  flex: 2,
//                  child: Container(
//                    padding: EdgeInsets.only(left: 10, top: 10),
//                    child: Image.asset(
//                      'images/furniture.jpg',
//                      fit: BoxFit.cover,
//                    ),
//                  )),
//              Expanded(
//                flex: 3,
//                child: Container(
//                  padding: EdgeInsets.only(right: 10, top: 10, left: 20),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text(
//                        'Title: ${houses[idx].title}',
//                        style: const TextStyle(
//                          fontWeight: FontWeight.w500,
//                          fontSize: 18.0,
//                        ),
//                      ),
//                      const Padding(
//                          padding: EdgeInsets.symmetric(vertical: 3.0)),
//                      Text(
//                        'Category: ${houses[idx].category}',
//                        style: const TextStyle(fontSize: 15.0),
//                      ),
//                      const Padding(
//                          padding: EdgeInsets.symmetric(vertical: 2.0)),
//                      Text(
//                        'Status: ${houses[idx].status}',
//                        style: const TextStyle(fontSize: 15.0),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
        ),
      );
    }

    return Scaffold(
      body: BlocBuilder<HouseBloc, HouseState>(
        builder: (_, state) {
          if (state is HouseOperationFailure) {
            return Container(
              width: double.infinity,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'images/not_found.svg',
                      height: 200,
                    ),
                    Text('Could not do House operation')
                  ],
                )
            );
          }

          if (state is HousesLoadSuccess) {
            final houses = state.houses;

            return ListView(
              children: <Widget>[
                titleSection,
                inputSection,
                suggestionSection,
                nearYouSection,
                _recentSearchesSection,
                _houseBuilder(houses),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),

    );
  }
}
