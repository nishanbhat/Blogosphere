import 'package:blog_app/pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blog_app/NetworkHandler.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  String errorTextUser;
  String errorTextEmail;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pic2.webp"), fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.purple[300]],
            //   begin: const FractionalOffset(0.0, 1.0),
            //   end: const FractionalOffset(0.0, 1.0),
            //   stops: [0.0, 1.0],
            //   tileMode: TileMode.repeated,
            // ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _globalkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SIGN UP",
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
                  emailTextField(),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      await checkUserAndEmail();

                      if (_globalkey.currentState.validate() && validate) {
                        // we send data to rest api server
                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "email": _emailController.text,
                          "password": _passwordController.text,
                        };
                        print(data);
                        // var responseRegister =
                        //     await networkHandler.post("/user/register", data);
                        var responseRegister = await networkHandler.post(
                            "/user/getVerificationMail", data);
                        if (responseRegister == null) {
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
                        } else if (responseRegister.statusCode == 200 ||
                            responseRegister.statusCode == 201) {
                          setState(() {
                            circular = false;
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
                                            "Activate your account by clicking on the link sent to your mail before logging in",
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
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                    WelcomePage.routeName,
                                                    (route) => false,
                                                  );
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Colors.purpleAccent,
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

                        setState(() {
                          circular = false;
                        });
                      } else {
                        setState(() {
                          circular = false;
                        });
                      }
                    },
                    child: circular
                        ? CircularProgressIndicator()
                        : Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blueGrey[700],
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
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

  checkUserAndEmail() async {
    if (_usernameController.text.length == 0 ||
        (_emailController.text.length == 0 ||
            !_emailController.text.contains("@"))) {
      setState(() {
        // circular = false;
        validate = false;
        errorTextUser = _usernameController.text.length == 0
            ? "Username can't be empty"
            : null;
        errorTextEmail = _emailController.text.length == 0
            ? "Email can't be empty"
            : (!_emailController.text.contains("@")
                ? "Email is Invalid"
                : null);
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");
      var response1 =
          await networkHandler.get("/user/checkemail/${_emailController.text}");
      if (response == null || response1 == null) {
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
          circular = false;
        });
      } else if (response["Status"] || response1["Status"]) {
        setState(() {
          // circular = false;
          // networkErr = false;
          validate = false;
          errorTextUser = response["Status"] ? "Username already taken" : null;
          errorTextEmail = response1["Status"] ? "Email already taken" : null;
        });
      } else {
        setState(() {
          // circular = false;
          // networkErr = false;
          validate = true;
        });
      }
    }
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
            Icons.person_outline,
            color: Colors.green,
          ),
          labelText: 'UserName',
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
    //   child: Column(
    //     children: [
    //       Text("Username"),
    //       TextFormField(
    //         controller: _usernameController,
    //         // focusNode: _usernameFocusNode,
    //         textInputAction: TextInputAction.next,
    //         // onFieldSubmitted: (_) {
    //         //   FocusScope.of(context).requestFocus(_emailFocusNode);
    //         // },
    //         decoration: InputDecoration(
    //           errorText: validate ? null : errorTextUser,
    //           focusedBorder: UnderlineInputBorder(
    //             borderSide: BorderSide(
    //               color: Colors.black,
    //               width: 2,
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget emailTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
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

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
    //   child: Column(
    //     children: [
    //       Text("Email"),
    //       TextFormField(
    //         controller: _emailController,
    //         keyboardType: TextInputType.emailAddress,
    //         // focusNode: _emailFocusNode,
    //         textInputAction: TextInputAction.next,
    //         // onFieldSubmitted: (_) {
    //         //   FocusScope.of(context).requestFocus(_passwordFocusNode);
    //         // },
    //         // validator: (value) {
    //         //   if (value.isEmpty) return "Email can't be empty";
    //         //   if (!value.contains("@")) return "Email is Invalid";
    //         //   return null;
    //         // },
    //         decoration: InputDecoration(
    //           errorText: validate ? null : errorTextEmail,
    //           focusedBorder: UnderlineInputBorder(
    //             borderSide: BorderSide(
    //               color: Colors.black,
    //               width: 2,
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget passwordTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _passwordController,
        // focusNode: _passwordFocusNode,
        validator: (value) {
          if (value.isEmpty) return "Password can't be empty";
          if (value.length < 8) return "Password length must have >=8";
          return null;
        },
        obscureText: vis,
        decoration: InputDecoration(
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

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
    //   child: Column(
    //     children: [
    //       Text("Password"),
    //       TextFormField(
    //         controller: _passwordController,
    //         // focusNode: _passwordFocusNode,
    //         validator: (value) {
    //           if (value.isEmpty) return "Password can't be empty";
    //           if (value.length < 8) return "Password length must have >=8";
    //           return null;
    //         },
    //         obscureText: vis,
    //         decoration: InputDecoration(
    //           suffixIcon: IconButton(
    //             icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
    //             onPressed: () {
    //               setState(() {
    //                 vis = !vis;
    //               });
    //             },
    //           ),
    //           helperText: "Password length should have >=8",
    //           helperStyle: TextStyle(
    //             fontSize: 14,
    //           ),
    //           focusedBorder: UnderlineInputBorder(
    //             borderSide: BorderSide(
    //               color: Colors.black,
    //               width: 2,
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
