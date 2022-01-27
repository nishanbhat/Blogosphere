import 'package:flutter/material.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({ Key? key }) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body = Center(
        child: Text("Create Profile"),
        ),
    );
  }
}