import 'package:flutter/material.dart';
import 'package:onepay_app/models/errors.dart';
import 'package:recase/recase.dart';

void showUnableToConnectError(BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      ReCase(UnableToConnectError).sentenceCase,
      style: TextStyle(color: Colors.orange),
    ),
  );
  try {
    Scaffold.of(context).showSnackBar(snackBar);
  } catch (e) {
    ///TODO: should remove the line below, should only be used for development purpose
    throw (e);
  }
}

void showServerError(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(
      ReCase(content).sentenceCase,
      style: TextStyle(color: Colors.orange),
    ),
  );
  try {
    Scaffold.of(context).showSnackBar(snackBar);
  } catch (e) {
    ///TODO: should remove the line below, should only be used for development purpose
    throw (e);
  }
}

void showInternalError(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(
      ReCase(content).sentenceCase,
      style: TextStyle(color: Colors.orange),
    ),
  );
  try {
    Scaffold.of(context).showSnackBar(snackBar);
  } catch (e) {
    ///TODO: should remove the line below, should only be used for development purpose
    throw (e);
  }
}
