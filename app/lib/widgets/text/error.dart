import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String text;

  ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).errorColor,
          fontSize: Theme.of(context).textTheme.overline.fontSize),
    );
  }
}
