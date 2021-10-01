import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:questt/helper/Color.dart';
import 'package:questt/helper/apis.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/views/pages/login_screen.dart';

Widget alertDialog(BuildContext context) {
  return AlertDialog(
    content: Text("Do you Really want to logout?"),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          getVerifyUser(context);
        },
      )
    ],
  );
}

Future<void> getVerifyUser(BuildContext context) async {
  try {
    String upDatedtoken = await getPrefrence(TOKEN);
    var data = {AUTH: 'bearer $upDatedtoken'};
    Response response = await post(getLogoutApi, headers: data)
        .timeout(Duration(seconds: timeOut));
    var getdata = json.decode(response.body);

    debugPrint('$getdata');

    int code = getdata["code"];
    String msg = getdata["status"];
    if (code == 200) {
      setSnackbar(msg, context);
      Future.delayed(Duration(seconds: 1)).then((_) {
        setPrefrence(TOKEN, '');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LogInScreen();
        }));
      });
    } else {
      setSnackbar(msg, context);
    }
  } on TimeoutException catch (_) {}
}

setSnackbar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content: new Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: colors.primary,
    elevation: 1.0,
  ));
}
