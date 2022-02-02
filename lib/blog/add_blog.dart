import 'package:flutter/material.dart';


class AddBlog extends StatefulWidget {
  const AddBlog({ Key? key }) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Blog")
    );
  }
}
