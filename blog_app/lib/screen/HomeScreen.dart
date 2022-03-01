import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blog_app/blog/Blogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../blog/addBlog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();

  List<double> _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
          if (_userAccelerometerValues != null) {
            if (_userAccelerometerValues[1] > 2 &&
                _userAccelerometerValues[1] < 4) {
              // add blog
              Navigator.of(context).pushNamed(AddBlog.routeName);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Blogs(
        url: "/blogPost/getAllBlogs",
      ),
    );
  }
}
