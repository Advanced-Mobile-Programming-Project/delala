import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserSearchPage extends StatelessWidget {
  //    input section
  Widget inputSection = Container(
    margin: EdgeInsets.only(top: 20, bottom: 30),
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

  //    searched item builder
  Container _searchedItemBuilder(
      String imgPath, String item, String city, context) {
    double addressWidth = MediaQuery.of(context).size.width * 0.5;
    double mortgageWidth = MediaQuery.of(context).size.width * 0.4;
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Image.asset(
              imgPath,
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
                      width: addressWidth,
                      child: Flexible(
                        child: Text(
                          'Victoria Apartments',
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
                                    '3 Beds',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                  '2 Baths',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                          ],
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        width: addressWidth,
                        child: Flexible(
                            child: Text(
                          '3rd st,Los Angeles, CA 90036',
                          style: Theme.of(context).textTheme.bodyText1,
                        )))
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      '\$8,948',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                        width: mortgageWidth,
                        child: Flexible(
                            child: Text(
                          'Est. Mortgage \$113/mo',
                          style: Theme.of(context).textTheme.bodyText1,
                        ))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Apartments',
            style: TextStyle(fontSize: 18.0, color: Colors.black87),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: ListView(
            children: [
              inputSection,
              Column(
                children: [
                  _searchedItemBuilder('images/liben.jfif', 'Studio Apartment',
                      'Los Angeles, CA', context),
                  _searchedItemBuilder(
                      'images/liben.jfif', '3B Condo', 'Encino, CA', context),
                  _searchedItemBuilder('images/liben.jfif', '2B Condo',
                      'Los Angeles, CA', context)
                ],
              )
            ],
          ),
        ));
  }
}
