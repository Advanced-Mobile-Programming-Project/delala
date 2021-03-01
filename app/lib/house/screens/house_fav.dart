import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HouseFavotites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/not_found.svg',
                height: 200,
              ),
              Text('Could not do Favs operation')
            ],
          ),
      ),
    );
  }
}
