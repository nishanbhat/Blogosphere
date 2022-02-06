import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/HomePage.dart';
import 'package:blog_app/pages/ForgotPassword.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // String errorText;
  String errorTextUser;
  String errorTextPass;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  // final _usernameFocusNode = FocusNode();
  // final _emailFocusNode = FocusNode();
  // final _passwordFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   // _usernameFocusNode.dispose();
  //   // _emailFocusNode.dispose();
  //   // _passwordFocusNode.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green[200]],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SIGN IN",
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
                  usernameTextField(),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ForgotPassword.routeName);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpPage.routeName);
                        },
                        child: Text(
                          "New User?",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      if (_usernameController.text.length == 0 ||
                          _passwordController.text.length == 0) {
                        setState(() {
                          circular = false;
                          validate = false;
                          errorTextUser = _usernameController.text.length == 0
                              ? "Username can't be empty"
                              : null;
                          errorTextPass = _passwordController.text.length == 0
                              ? "Password can't be empty"
                              : null;
                        });
                      } else {
                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "password": _passwordController.text,
                        };
                        var response =
                            await networkHandler.post("/user/login", data);
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
                          setState(() {
                            validate = false;
                            circular = false;
                          });
                        } else if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          // Write value
                          await storage.write(
                            key: "token",
                            value: output["token"],
                          );
                          await storage.write(
                            key: "username",
                            value: data["username"],
                          );
                          await storage.write(
                            key: "id",
                            value: output["id"],
                          );
                          setState(() {
                            validate = true;
                            circular = false;
                          });
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => HomePage(),
                          //     ),
                          //     (route) => false);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName, (route) => false);
                        } else {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          print("3");
                          print(output);
                          setState(() {
                            validate = false;
                            // errorText = output["msg"];
                            errorTextUser = output["msg"].contains("user")
                                ? output["msg"]
                                : null;
                            errorTextPass = output["msg"].contains("password")
                                ? output["msg"]
                                : null;
                            circular = false;
                          });
                        }
                      }
                    },
                    child: circular
                        ? CircularProgressIndicator()
                        : Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xff00A86B),
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget usernameTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _usernameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextUser,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person_outline_sharp,
            color: Colors.green,
          ),
          labelText: 'UserName',
        ),
      ),
    );

    // return Column(
    //   children: [
    //     Text("Username"),
    //     TextFormField(
    //       controller: _usernameController,
    //       // focusNode: _usernameFocusNode,
    //       textInputAction: TextInputAction.next,
    //       // onFieldSubmitted: (_) {
    //       //   FocusScope.of(context).requestFocus(_emailFocusNode);
    //       // },
    //       decoration: InputDecoration(
    //         errorText: validate ? null : errorTextUser,
    //         focusedBorder: UnderlineInputBorder(
    //           borderSide: BorderSide(
    //             color: Colors.black,
    //             width: 2,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: _passwordController,
        // focusNode: _passwordFocusNode,
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
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline_sharp,
            color: Colors.green,
          ),
          labelText: 'Password',
        ),
      ),
    );

    // return Column(
    //   children: [
    //     Text("Password"),
    //     TextFormField(
    //       controller: _passwordController,
    //       // focusNode: _passwordFocusNode,
    //       obscureText: vis,
    //       decoration: InputDecoration(
    //         errorText: validate ? null : errorTextPass,
    //         suffixIcon: IconButton(
    //           icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
    //           onPressed: () {
    //             setState(() {
    //               vis = !vis;
    //             });
    //           },
    //         ),
    //         // helperText: "Password length should have >=8",
    //         // helperStyle: TextStyle(
    //         //   fontSize: 14,
    //         // ),
    //         focusedBorder: UnderlineInputBorder(
    //           borderSide: BorderSide(
    //             color: Colors.black,
    //             width: 2,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}
