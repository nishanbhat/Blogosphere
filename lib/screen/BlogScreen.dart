import 'dart:convert';

import 'package:blog_app/screen/CommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/BlogModel.dart';

import '../blog/updateBlog.dart';

class BlogScreen extends StatefulWidget {
  static const routeName = '/blog-screen';

  final Map<String, dynamic> data;

  const BlogScreen(
    this.data,
  );

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  BlogModel blog;
  NetworkHandler networkHandler;
  final storage = FlutterSecureStorage();
  String user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();

    setState(() {
      blog = widget.data["blog"];
      networkHandler = widget.data["networkHandler"];
    });
  }

  void fetchUser() async {
    String tp = await storage.read(key: "id");
    print(tp);
    print("done");
    setState(() {
      user = tp;
    });
  }

  ///to show error  message
  showToast(BuildContext context, String msg) {
    Widget toast = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.grey.shade500,
          ),
          child: Center(
              child: Text(
            msg,
            maxLines: 3,
            textAlign: TextAlign.center,
          )),
        ));
    FlutterToast(context).showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            // height: 365,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: blog.coverImage.url != ""
                            ? networkHandler.getImage(blog.coverImage.url)
                            : AssetImage("assets/no_image.jpeg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      blog.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              CommentScreen.routeName,
                              arguments: {
                                "blogId": blog.sId,
                              },
                            );
                          },
                          child: Icon(
                            Icons.chat_bubble,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          NumberFormat.compact().format(blog.comments.length),
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            var response = await networkHandler.patch(
                              "/blogPost/${blog.sId}/like",
                              {"": ""},
                            );
                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              setState(() {
                                blog = BlogModel.fromJson(
                                  json.decode(
                                    response.body,
                                  )["blog"],
                                );
                              });
                            } else {
                              print("done");
                              showToast(
                                  context,
                                  json.decode(
                                    response.body,
                                  )["msg"]);
                            }
                          },
                          child: Icon(
                            Icons.thumb_up,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          NumberFormat.compact().format(blog.likes),
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            var response = await networkHandler.patch(
                              "/blogPost/${blog.sId}/dislike",
                              {"": ""},
                            );
                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              setState(() {
                                blog = BlogModel.fromJson(
                                  json.decode(
                                    response.body,
                                  )["blog"],
                                );
                              });
                            } else {
                              print("done");
                              showToast(
                                  context,
                                  json.decode(
                                    response.body,
                                  )["msg"]);
                            }
                          },
                          child: Icon(
                            Icons.thumb_down,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          NumberFormat.compact().format(blog.dislikes),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // delete button
          blog.user == user
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var response = await networkHandler.delete(
                                "/blogPost/delete/${blog.sId}",
                              );
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                Navigator.of(context).pop();
                              } else {
                                showToast(
                                    context,
                                    json.decode(
                                      response.body,
                                    )["msg"]);
                              }
                            },
                            child: Icon(
                              Icons.delete,
                              size: 25,
                            ),
                          ),
                          Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                UpdateBlog.routeName,
                                arguments: BlogModel(
                                    title: blog.title,
                                    body: blog.body,
                                    sId: blog.sId),
                              );
                            },
                            child: Icon(
                              Icons.update,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Text(blog.body),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
