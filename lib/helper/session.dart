import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:questt/helper/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

String validateMob(String value, String msg1, String msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.length < 10) {
    return msg2;
  }
  return null;
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

Future<bool> checkLoginValue() async {
  SharedPreferences loginCheck = await SharedPreferences.getInstance();
  return loginCheck.getBool("login") ?? false;
}

setVisitingFalg(value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("login", value);
}

setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

setPrefrenceList(String key, String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> valueList = await getPrefrenceList(key);
  if (!valueList.contains(query)) {
    if (valueList.length > 4) valueList.removeAt(0);
    valueList.add(query);

    prefs.setStringList(key, valueList);
  }
}

Future<List<String>> getPrefrenceList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key) ?? [];
}

Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Map<String, String> get headers =>
    {"Content-Type": 'application/json', "Accept": 'application/json'};

Map<String, String> get subjectHeader => {
      "Authorization": 'bearer ' + TOKEN,
    };
