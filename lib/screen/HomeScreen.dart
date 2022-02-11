import 'package:blog_app/blog/Blogs.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Blogs(
        url: "/blogPost/getAllBlogs",
      ),
    );
  }
}
