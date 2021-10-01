import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:questt/helper/Color.dart';
import 'package:questt/helper/apis.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/model/user_respose.dart';
import 'package:questt/views/pages/home_page.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final String countryCode;

  const OtpScreen({Key key, this.mobile, this.countryCode}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  String otp;
  AnimationController controller;
  bool _isNetworkAvail;

  Duration get duration => controller.duration * controller.value;

  bool get expired => duration.inSeconds == 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    controller.reverse(from: 1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      ENTER_OTP,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      OTP_INSTRUCTION,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.mobile}',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.edit,
                          color: colors.primary,
                          size: 15,
                        )
                      ],
                    ),
                    otpLayout(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return new Text(
                                '00:${duration.inSeconds}',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            }),
                        InkWell(
                          onTap: () => setState(() {
                            controller.reset();
                            controller.reverse(from: 1);
                          }),
                          child: Text(
                            RESEND_OTP,
                            style: TextStyle(
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: InkWell(
                        onTap: () {
                          validateAndSubmit();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.teal),
                          width: double.infinity,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                                child: Text(
                              CONFIRM_AND_VERIFY,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(NEED_HELP),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      CLICK_HERE,
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateAndSubmit() async {
    checkNetwork();
  }

  Future<void> getVerifyOtp() async {
    try {
      var data = {
        COUNTRY_CODE: '91',
        MOBILE: '917398608888',
        CODE: '11111',
        DEVICE_TOKEN: 'my device token'
      };
      Response response =
          await post(getVerifyOtpApi, body: json.encode(data), headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      int code = getdata["code"];
      String msg = getdata["status"];

      if (code == 200) {
        setSnackbar(msg);

        UsersData usersData = UsersData.fromJson(getdata);
        LogInData logInData = usersData.data;
        User data = logInData.user;
        Data usData = data.data;

        setPrefrence(TOKEN, logInData.token);
        setPrefrence(USERNAME, 'Kanhaiya');
        Future.delayed(Duration(seconds: 1)).then((_) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        });
      } else {
        setSnackbar(msg);
      }
    } on TimeoutException catch (_) {
      setSnackbar(WENT_WRONG);
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

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyOtp();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      });
    }
  }

  otpLayout() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 50.0,
          end: 50.0,
        ),
        child: Center(
            child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder: FixedColorBuilder(Colors.black),
                ),
                currentCode: otp,
                codeLength: 5,
                onCodeChanged: (String code) {
                  otp = code;
                },
                onCodeSubmitted: (String code) {
                  otp = code;
                })));
  }
}
