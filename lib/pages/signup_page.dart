// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.blueAccent, Colors.yellowAccent],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(0.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up with Email",
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
                onTap: () {
                  if(_globalKey.currentState!.validate())
                  {
                    //send data to the rest erver
                    // ignore: avoid_print
                    print("validated");
                  }
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87),
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
    );
  }
}

Widget usernameTextField() {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Username"),
          TextFormField(
            // controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) return "Username can't be empty";
              return null;
            },
            decoration: InputDecoration(
              // errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget emailTextField() {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email"),
          TextFormField(
            // controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is Invalid";
              return null;
            },
            decoration: InputDecoration(
              // errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget passwordTextField() {
  bool vis = true;
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
          ),
          TextFormField(
            obscureText: vis,
            validator: (value) {
              if (value!.isEmpty) return "Password can't be empty";
              if (value.length <= 8) return "Password length must have <=8";
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                // ignore: dead_code
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperText: "Password length should not exceed 8 characters",
              helperStyle: TextStyle(
                fontSize: 10,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ));
}

void setState(Null Function() param0) {}
