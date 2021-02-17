import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onepay_app/main.dart';
import 'package:onepay_app/models/access.token.dart';
import 'package:onepay_app/models/app.meta.dart';
import 'package:onepay_app/models/constants.dart';
import 'package:onepay_app/utils/exceptions.dart';
import 'package:onepay_app/utils/localdata.handler.dart';

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
    AccessToken accessToken =
        OnePay.of(context).accessToken ?? await getLocalAccessToken();

    AppMeta appMeta = OnePay.of(context).appMetaData;
    if (appMeta == null) {
      appMeta = await getAppMeta();
      OnePay.of(context).appMetaData = appMeta;
    }

    if (accessToken == null) {
      throw AccessTokenNotFoundException();
    }

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${accessToken.apiKey}:${accessToken.accessToken}'));
    return await http.get(requestURL, headers: <String, String>{
      'User-Agent': "${appMeta.name} ${appMeta.version} ${appMeta.userAgent}",
      'Content-Type': 'application/x-www-form-urlencoded',
      'authorization': basicAuth,
    }).timeout(Duration(minutes: 1));
  }

  Future<http.Response> post(
      BuildContext context, Map<String, dynamic> body) async {
    AccessToken accessToken =
        OnePay.of(context).accessToken ?? await getLocalAccessToken();

    AppMeta appMeta = OnePay.of(context).appMetaData;
    if (appMeta == null) {
      appMeta = await getAppMeta();
      OnePay.of(context).appMetaData = appMeta;
    }

    if (accessToken == null) {
      throw AccessTokenNotFoundException();
    }

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${accessToken.apiKey}:${accessToken.accessToken}'));
    return await http
        .post(
          requestURL,
          headers: <String, String>{
            'User-Agent':
                "${appMeta.name} ${appMeta.version} ${appMeta.userAgent}",
            'Content-Type': 'application/x-www-form-urlencoded',
            'authorization': basicAuth,
          },
          body: body,
        )
        .timeout(Duration(minutes: 1));
  }

  Future<http.Response> put(
      BuildContext context, Map<String, dynamic> body) async {
    AccessToken accessToken =
        OnePay.of(context).accessToken ?? await getLocalAccessToken();

    AppMeta appMeta = OnePay.of(context).appMetaData;
    if (appMeta == null) {
      appMeta = await getAppMeta();
      OnePay.of(context).appMetaData = appMeta;
    }

    if (accessToken == null) {
      throw AccessTokenNotFoundException();
    }

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${accessToken.apiKey}:${accessToken.accessToken}'));
    return await http
        .put(
          requestURL,
          headers: <String, String>{
            'User-Agent':
                "${appMeta.name} ${appMeta.version} ${appMeta.userAgent}",
            'Content-Type': 'application/x-www-form-urlencoded',
            'authorization': basicAuth,
          },
          body: body,
        )
        .timeout(Duration(minutes: 1));
  }

  Future<http.Response> delete(
      BuildContext context, Map<String, dynamic> body) async {
    AccessToken accessToken =
        OnePay.of(context).accessToken ?? await getLocalAccessToken();

    AppMeta appMeta = OnePay.of(context).appMetaData;
    if (appMeta == null) {
      appMeta = await getAppMeta();
      OnePay.of(context).appMetaData = appMeta;
    }

    if (accessToken == null) {
      throw AccessTokenNotFoundException();
    }

    String query = "?";
    int index = 0;
    body.forEach((key, value) {
      if (index > 0) {
        query += "&";
      }
      query += "$key=$value";
      index++;
    });

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${accessToken.apiKey}:${accessToken.accessToken}'));
    return await http.delete(
      requestURL + query,
      headers: <String, String>{
        'User-Agent':
            "${appMeta.name} ${appMeta.version} ${appMeta.userAgent}",
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': basicAuth,
      },
    ).timeout(Duration(minutes: 1));
  }
}
