import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:questt/helper/apis.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/model/slide.dart';
import 'package:questt/views/pages/otp_page.dart';
import 'package:questt/views/widgets/slide_dots.dart';
import 'package:questt/views/widgets/slider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  var _current = 0;
  final mobileController = TextEditingController();
  String mobile, id, countrycode, countryName, mobileno;
  FocusNode passFocus, monoFocus = FocusNode();
  bool _isNetworkAvail = true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Slide> slides = Slide.slides;
  final PageController _pageController = PageController(initialPage: 0);

  setMobileNo() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.number,
        controller: mobileController,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        focusNode: monoFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (val) => validateMob(val, 'Mobile Number Required',
            'Mobile Number not be less than 10 digit'),
        onSaved: (String value) {
          mobile = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter Mobile Number here...',
          border: InputBorder.none,
          hintStyle: Theme.of(this.context)
              .textTheme
              .subtitle2
              .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  _onPageChanged(int index) {
    setState(() {
      _current = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        height: 400,
                        width: 400,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          onPageChanged: _onPageChanged,
                          controller: _pageController,
                          itemBuilder: (context, index) => SlideItems(
                            index: index,
                          ),
                          itemCount: slides.length,
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Container(
                            height: 12,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < slides.length; i++)
                                  if (i == _current)
                                    SlideDots(isActive: true)
                                  else
                                    SlideDots(isActive: false)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Container(
                  width: double.infinity,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: double.infinity,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.greenAccent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.greenAccent
                                                  .withOpacity(0.12)),
                                          child: setCountryCode(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: setMobileNo(),
                                      )
                                    ],
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              validateAndSubmit();
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Get OTP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Need Help? '),
                              InkWell(
                                child: Text(
                                  'Click here',
                                  style:
                                      TextStyle(color: Colors.greenAccent[100]),
                                ),
                              )
                            ])
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      });
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.teal,
      elevation: 1.0,
    ));
  }

  Future<void> getVerifyUser() async {
    debugPrint('Coming');
    debugPrint('$mobile +  $countrycode');
    try {
      var data = {MOBILE: '917398608888', COUNTRY_CODE: countrycode, TNC: 1};
      Response response =
          await post(getSignUp, body: json.encode(data), headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      debugPrint('$getdata');

      int code = getdata["code"];
      String msg = getdata["message"];

      debugPrint('$code +  $msg');
      if (code == 201) {
        setSnackbar(msg);

        // setPrefrence(MOBILE, mobile);
        // setPrefrence(COUNTRY_CODE, countrycode);
        Future.delayed(Duration(seconds: 1)).then((_) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        mobile: mobile,
                        countryCode: countrycode,
                      )));
        });
      } else {
        setSnackbar(msg);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something went wrong");
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  setCountryCode() {
    double width = double.infinity;
    double height = double.infinity * 0.9;
    return CountryCodePicker(
        showCountryOnly: true,
        flagWidth: 20,
        showFlag: false,
        boxDecoration: BoxDecoration(
          color: Colors.white,
        ),
        searchDecoration: InputDecoration(
          hintText: 'Search Country',
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
        ),
        showOnlyCountryWhenClosed: false,
        initialSelection: 'IN',
        dialogSize: Size(width, height),
        alignLeft: true,
        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        onChanged: (CountryCode countryCode) {
          countrycode = countryCode.toString().replaceFirst("+", "");
          countryName = countryCode.name;
        },
        onInit: (code) {
          countrycode = code.toString().replaceFirst("+", "");
        });
  }
}
