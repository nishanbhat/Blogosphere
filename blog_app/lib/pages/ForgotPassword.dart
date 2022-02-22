import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/widgets/Otp.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _emailController = TextEditingController();

  String errorTextEmail;
  bool validate = false;
  bool circular = false;
  bool circular2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.purple[300]],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _globalkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "FORGOT PASSWORD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter the email address assocated with your account and we'll send an email with the OTP to reset your password.",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                      // letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  emailTextField(),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      if (_emailController.text.length == 0 ||
                          !_emailController.text.contains("@")) {
                        setState(() {
                          circular = false;
                          validate = false;
                          errorTextEmail = _emailController.text.length == 0
                              ? "Email can't be empty"
                              : "Email is Invalid";
                        });
                      } else {
                        // print("proceed with code");
                        var username_response = await networkHandler
                            .get("/user/checkemail/${_emailController.text}");
                        if (username_response == null ||
                            !username_response["Status"]) {
                          setState(() {
                            circular = false;
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                username_response == null
                                    ? 'Some eror occured. Please try later'
                                    : "Email isn't registered",
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        } else {
                          Map<String, String> data = {
                            "email": _emailController.text,
                          };
                          var response = await networkHandler.post(
                              "/user/forgotPassword", data);
                          var userid =
                              json.decode(response.body)["user"]["_id"];
                          // var userid = "userid";
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushNamed(
                            Otp.routeName,
                            arguments: {
                              "email": _emailController.text,
                              "userId": "$userid"
                            },
                          );
                        }
                      }
                      setState(() {
                        circular = false;
                      });
                    },
                    child: circular
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff00A86B),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "NEXT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                  InkWell(
                    onTap: () async {
                      print("open dialog box");
                      if (_emailController.text.length == 0 ||
                          !_emailController.text.contains("@")) {
                        setState(
                          () {
                            validate = false;
                            errorTextEmail = _emailController.text.length == 0
                                ? "Email can't be empty"
                                : (!_emailController.text.contains("@")
                                    ? "Email is Invalid"
                                    : null);
                          },
                        );
                      } else {
                        setState(() {
                          circular2 = true;
                        });
                        var username_response = await networkHandler
                            .get("/user/checkemail/${_emailController.text}");
                        if (username_response == null) {
                          setState(() {
                            circular2 = false;
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Some eror occured. Please try later',
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            circular2 = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            username_response["Status"]
                                                ? "Your username is : ${username_response["username"]}"
                                                : "Email isn't registered",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: circular2
                        ? CircularProgressIndicator()
                        : Text(
                            "Just forgot your username?",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      // changing it to textfield instead of textformfield
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextEmail,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.tealAccent,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.green,
          ),
          labelText: 'Email',
        ),
      ),
    );
  }
}
