import 'package:flutter/material.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/BlogModel.dart';
import 'package:blog_app/widgets/BlogCard.dart';
import 'package:blog_app/screen/BlogScreen.dart';

class Blogs extends StatefulWidget {
  final String url;

  Blogs({
    @required this.url,
  });

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  List<BlogModel> blogs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    // Iterable list = response["data"];
    setState(() {
      var tp = (response["data"] as Iterable)
          .map((model) => BlogModel.fromJson(model))
          .toList();
      blogs = tp.reversed.toList();
      circular = false;
    });
    // print(blogs);
  }

  @override
  Widget build(BuildContext context) {
    return circular
        ? Center(child: CircularProgressIndicator())
        : blogs.length > 0
            ? ListView.builder(
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        BlogScreen.routeName,
                        arguments: {
                          "blog": blogs[index],
                          "networkHandler": networkHandler,
                        },
                      );
                    },
                    child: BlogCard(
                      blog: blogs[index],
                      networkHandler: networkHandler,
                    ),
                  );
                },
                itemCount: blogs.length,
              )
            : Center(
                child: Text("No Blogs to show."),
              );
  }
}
