import 'package:delala/utils/custom_icons.dart';
import 'package:flutter/material.dart';

class SignUpCompleted extends StatelessWidget {
  final bool visible;
  final AnimationController controller;

  SignUpCompleted({this.visible, @required this.controller});

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });

    return Visibility(
      visible: visible ?? false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: offsetAnimation,
                builder: (buildContext, child) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: offsetAnimation.value + 24.0,
                        right: 24.0 - offsetAnimation.value,
                        bottom: 10),
                    child: Center(
                      child: Icon(
                        CustomIcons.complete,
                        size: 80,
                        color: Colors.black,
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Completed",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ),
            Text(
              "Congratulations, you have taken the first step towards better controlling your personal finances!",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
