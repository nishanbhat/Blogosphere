import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/BlogModel.dart';
import 'package:blog_app/pages/HomePage.dart';

class UpdateBlog extends StatefulWidget {
  static const routeName = '/update-blog';
  BlogModel blogModel = BlogModel();
  UpdateBlog(this.blogModel);
  @override
  _UpdateBlogState createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();

  NetworkHandler networkHandler = NetworkHandler();
  bool circular = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _title.text = widget.blogModel.title;
      _body.text = widget.blogModel.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Update Blog',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            addButton(),
          ],
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.tealAccent,
              width: 2,
            ),
          ),
          labelText: "updateTitle",
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.tealAccent,
              width: 2,
            ),
          ),
          labelText: "Provide Body Your Blog",
        ),
        maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return Center(
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purpleAccent),
        child: InkWell(
          onTap: () async {
            if (_globalkey.currentState.validate()) {
              setState(() {
                circular = true;
              });
              BlogModel blog = BlogModel(
                body: _body.text,
                title: _title.text,
              );
              var response = await networkHandler.update(
                  "/blogPost/updateBlog/${widget.blogModel.sId}",
                  blog.toJson());

              if (response.statusCode == 200 || response.statusCode == 201) {
                Navigator.of(context).pop();
              } else {
                setState(() {
                  circular = false;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName,
                  (route) => false,
                );
              }
            } else {
              setState(() {
                circular = false;
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Network Error',
                  ),
                  duration: Duration(
                    seconds: 1,
                  ),
                ),
              );
            }
          },
          child: Center(
              child: circular
                  ? CircularProgressIndicator()
                  : Text(
                      "update Blog",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
        ),
      ),
    );
  }
}
