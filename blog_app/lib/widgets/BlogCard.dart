import 'package:flutter/material.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/BlogModel.dart';

class BlogCard extends StatelessWidget {
  final NetworkHandler networkHandler;
  final BlogModel blog;

  const BlogCard({@required this.blog, @required this.networkHandler});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        right: 8,
        left: 8,
        bottom: 8,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: blog.coverImage.url != ""
                        ? networkHandler.getImage(blog.coverImage.url)
                        : AssetImage("assets/no_image.jpeg"),
                    fit: BoxFit.fitWidth),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 177, 146, 146),
                    ),
                  ),
                  // borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  blog.title,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.55,
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.all(5),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.4,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: Colors.black,
  //             borderRadius: BorderRadius.circular(8),
  //             image: DecorationImage(
  //                 image: FileImage(
  //                   File(imagefile.path),
  //                 ),
  //                 fit: BoxFit.fitWidth),
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             padding: EdgeInsets.all(8),
  //             height: MediaQuery.of(context).size.height * 0.15,
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //                 color: Colors.white, borderRadius: BorderRadius.circular(9)),
  //             child: Text(
  //               title,
  //               overflow: TextOverflow.visible,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
