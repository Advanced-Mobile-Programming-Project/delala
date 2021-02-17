import 'package:flutter/material.dart';

class StepIcon extends AnimatedWidget {
  final iconData;
  final iconColor;
  final AnimationController sizeController;
  final sizeTween = Tween<double>(begin: 1, end: 1.2);

  StepIcon({Key key, this.iconData, this.sizeController, this.iconColor})
      : super(key: key, listenable: sizeController);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = sizeTween.animate(listenable);

    return Container(
      child: Icon(
        iconData,
        size: 15 * animation.value,
        color: iconColor,
      ),
      color: Colors.white,
    );
  }
}
