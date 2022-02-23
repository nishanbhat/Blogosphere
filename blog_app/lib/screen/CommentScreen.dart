import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/CommentsModel.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment-screen';

  final Map<String, dynamic> data;

  const CommentScreen(
    this.data,
  );

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool circular = true;
  List<CommentsModel> comments = [];
  NetworkHandler networkHandler = NetworkHandler();
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _message = TextEditingController();
  ScrollController _controller = ScrollController();
  final storage = FlutterSecureStorage();
  String user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
    fetchComments();
  }

  void fetchComments() async {
    var response = await networkHandler
        .get("/blogPost/getBlogComments/${widget.data["blogId"]}");
    // Iterable list = response["data"];
    setState(() {
      comments = (response["data"] as Iterable)
          .map((model) => CommentsModel.fromJson(model))
          .toList();
      circular = false;
    });
  }

  void fetchUser() async {
    String tp = await storage.read(key: "username");
    print(tp);
    print("done");
    setState(() {
      user = tp;
    });
  }

  void postComment() async {
    var response = await networkHandler.post(
        "/blogPost/${widget.data["blogId"]}/addComment",
        {"content": _message.text});
    print(json.decode(
      response.body,
    )['msg']);
    setState(() {
      comments.add(
        CommentsModel.fromJson(
          json.decode(
            response.body,
          )['msg'],
        ),
      );
      scroll();
    });
    _message.clear();
  }

  void scroll() {
    Timer(
      Duration(milliseconds: 300),
      () => _controller.jumpTo(
        _controller.position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    scroll();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text(
          "Comments",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: circular
                  ? Center(child: CircularProgressIndicator())
                  : comments.length > 0
                      ? Container(
                          child: ListView.builder(
                            controller: _controller,
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 16,
                            ),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              CommentsModel comment = comments[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          comment.user.username == user
                                              ? "You,"
                                              : "${comment.user.username},",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          Jiffy(DateTime.parse(
                                                  comment.createdAt))
                                              .fromNow(),
                                          // "${comment.createdAt.substring(11, 16)}, ${comment.createdAt.substring(0, 10)}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    // delete button
                                    comment.user.username == user
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  var response =
                                                      await networkHandler.delete(
                                                          "/blogPost/deleteComment/${comment.sId}");
                                                  print(response);
                                                  setState(() {
                                                    comments.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                    SelectableText(
                                      comment.content,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            "No comments yet",
                            ),
                        ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _globalkey,
                      child: TextFormField(
                        onTap: () {
                          scroll();
                        },
                        onFieldSubmitted: (val) {
                          postComment();
                        },
                        decoration: InputDecoration(
                          labelText: "Comment",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: _message,
                        ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.purpleAccent,
                    onPressed: () {
                      postComment();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
