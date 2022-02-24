import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/pages/WelcomePage.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = '/change-password';
  Map<String, String> data;

  ResetPassword(
    this.data,
  );

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool vis = true;
  bool circular = false;
  bool validate = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirm_passwordController = TextEditingController();
  String errorTextPass;
  String errorTextConfirmPass;
  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    print("${widget.data["token"]}");
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "RESET PASSWORD",
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
                passwordTextField(),
                confirmpasswordTextField(),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    if (_passwordController.text.length < 8 ||
                        _confirm_passwordController.text !=
                            _passwordController.text) {
                      setState(
                        () {
                          circular = false;
                          validate = false;
                          errorTextPass = _passwordController.text.length == 0
                              ? "Password can't be empty"
                              : _passwordController.text.length < 8
                                  ? "Password length must have >=8"
                                  : null;
                          errorTextConfirmPass =
                              _confirm_passwordController.text.length == 0
                                  ? "Confirm Password can't be empty"
                                  : _confirm_passwordController.text !=
                                          _passwordController.text
                                      ? "Password don't match"
                                      : null;
                        },
                      );
                    } else {
                      setState(() {
                        validate = true;
                      });
                      Map<String, String> toSend = {
                        "password": _confirm_passwordController.text,
                      };
                      // print("/user/update/${widget.data["userId"]}/${widget.data["token"]}");
                      var response = await networkHandler.patch(
                          "/user/update/${widget.data["userId"]}/${widget.data["token"]}",
                          toSend);
                      if (response == null) {
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
                      } else if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password successfully changed. Please login now',
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          WelcomePage.routeName,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              json.decode(response.body)['msg'],
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                      setState(() {
                        circular = false;
                      });
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
                              child: Text(
                                "NEXT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _passwordController,
        obscureText: vis,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextPass,
          suffixIcon: IconButton(
            icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                vis = !vis;
              });
            },
          ),
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
            Icons.lock_outline_sharp,
            color: Colors.green,
          ),
          labelText: 'Password',
          helperText: "Password length should have >=8",
          helperStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget confirmpasswordTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _confirm_passwordController,
        obscureText: true,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextConfirmPass,
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
            Icons.lock,
            color: Colors.green,
          ),
          labelText: 'Confirm Password',
          helperText: "Password should be same as above",
          helperStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
