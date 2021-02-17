import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final Widget child;
  final ShapeBorder shape;
  final Function onPressed;
  final Color color;
  final EdgeInsets padding;
  final bool loading;
  final FocusNode focusNode;

  LoadingButton(
      {this.child,
      this.shape,
      this.onPressed,
      this.color,
      this.loading,
      this.padding,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      focusNode: focusNode,
      child: loading
          ? Container(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Colors.white,
              ),
            )
          : child,
      shape: shape,
      padding: padding,
      onPressed: loading ? null : onPressed,
      color: color,
    );
  }
}
