import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/widgets/OtpScreen.dart';
import 'package:blog_app/widgets/ResetPassword.dart';

class Otp extends StatefulWidget {
  static const routeName = '/otp-screen';
  Map<String, String> data;

  Otp(
    this.data,
  );

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  NetworkHandler networkHandler = NetworkHandler();
  String token;

  Future<String> validateOtp(String otp) async {
    Map<String, dynamic> toSend = {
      "otp": int.parse(otp),
    };
    var response = await networkHandler.post(
        "/user/getotp/${widget.data["userId"]}", toSend);
    if (response == null) {
      return "Network Error";
    } else if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        token = json.decode(response.body)["token"];
      });
      return null;
    } else {
      return json.decode(response.body)["msg"];
    }
    // if (data["otp"] == 123456) {
    //   return null;
    // } else {
    //   return "Incorrect otp";
    // }
  }

  void moveToNextScreen(context) {
    Navigator.of(context).pushReplacementNamed(
      ResetPassword.routeName,
      arguments: {
        "token": token,
        "userId": "${widget.data["userId"]}",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data["userId"]);
    return OtpScreen.withGradientBackground(
      topColor: Colors.white,
      bottomColor: Colors.purple[300],
      icon: Icon(
        Icons.email,
        color: Colors.green,
      ),
      otpLength: 6,
      validateOtp: validateOtp,
      routeCallback: moveToNextScreen,
      title: "OTP Verification",
      subTitle: "Enter the code sent to ${widget.data["email"]}",
      titleColor: Colors.black,
      themeColor: Colors.black,
    );
  }
}
