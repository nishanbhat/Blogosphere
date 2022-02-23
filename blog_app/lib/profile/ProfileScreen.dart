import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/profile/CreateProfile.dart';
import 'package:blog_app/profile/MainProfile.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = FlutterSecureStorage();
  Widget page = Center(child: CircularProgressIndicator());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read();
    checkProfile();
  }

  void checkProfile() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await _read();
      if (data == null) {
        setState(() {
          page = Center(child: CircularProgressIndicator());
        });
        var response = await networkHandler.get("/profile/checkProfile");
        if (response == null) {
          setState(() {
            page = networkError();
          });
        } else if (response["Status"] == true) {
          setState(() {
            page = MainProfile();
          });
        } else {
          setState(() {
            page = button();
          });
        }
      } else {
        setState(() {
          page = MainProfile();
        });
      }
    });
  }

  dynamic _read() async {
    // await storage.delete(key: "profile");
    String profile = await storage.read(key: "profile");
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }

  Widget networkError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Network Error",
            textAlign: TextAlign.center,
            style: TextStyle(
              // color: Colors.deepOrange,
              fontSize: 18,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh_sharp),
          onPressed: () {
            checkProfile();
          },
        ),
      ],
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap to button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(CreateProfile.routeName);
            },
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Add Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
