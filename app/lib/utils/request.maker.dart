import 'package:delala/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpRequester {
  String baseURI = "http://$Host/api/v1";
  String requestURL = "";

  HttpRequester({@required String path}) {
    if (path.startsWith("/")) {
      requestURL = Uri.encodeFull(baseURI + path);
    } else {
      requestURL = Uri.encodeFull(baseURI + "/" + path);
    }
  }

  Future<http.Response> get(BuildContext context) async {
    return await http.get(requestURL, headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    }).timeout(Duration(minutes: 1));
  }

  Future<http.Response> post(
      BuildContext context, Map<String, dynamic> body) async {
    return await http
        .post(
          requestURL,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body,
        )
        .timeout(Duration(minutes: 1));
  }

  Future<http.Response> put(
      BuildContext context, Map<String, dynamic> body) async {
    return await http
        .put(
          requestURL,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body,
        )
        .timeout(Duration(minutes: 1));
  }

  Future<http.Response> delete(
      BuildContext context, Map<String, dynamic> body) async {
    String query = "?";
    int index = 0;
    body.forEach((key, value) {
      if (index > 0) {
        query += "&";
      }
      query += "$key=$value";
      index++;
    });

    return await http.delete(
      requestURL + query,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ).timeout(Duration(minutes: 1));
  }
}
