import 'dart:convert';

import 'package:blog_app/widgets/FingerAuth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/widgets/OverlayCard.dart';
import 'package:blog_app/models/BlogModel.dart';
import 'package:blog_app/pages/HomePage.dart';

class AddBlog extends StatefulWidget {
  static const routeName = '/add-blog';

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  IconData iconphoto = Icons.image;
  NetworkHandler networkHandler = NetworkHandler();
  bool circular = false;

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
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_imageFile != null && _title.text != "") {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => OverlayCard(
                        imagefile: _imageFile,
                        title: _title.text,
                      )),
                );
              } else {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please add image and title to preview',
                    ),
                    duration: Duration(
                      seconds: 1,
                    ),
                  ),
                );
              }
            },
            child: Text(
              "Preview",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          )
        ],
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
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: Colors.purpleAccent,
            ),
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              // currentFocus.unfocus();
              currentFocus.canRequestFocus = false;
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
              Future.delayed(Duration(milliseconds: 100), () {
                currentFocus.canRequestFocus = true;
              });
            },
          ),
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
            final isAuthenticate = await LocalAuthApi.authenticate();
            if (isAuthenticate == true) {
              if (_imageFile == null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please add an image',
                    ),
                    duration: Duration(
                      seconds: 1,
                    ),
                  ),
                );
                setState(() {
                  circular = false;
                });
              } else if (_imageFile != null &&
                  _globalkey.currentState.validate()) {
                setState(() {
                  circular = true;
                });
                BlogModel blog = BlogModel(
                  body: _body.text,
                  title: _title.text,
                );

                var response = await networkHandler.post(
                    "/blogPost/createBlog", blog.toJson());

                if (response.statusCode == 200 || response.statusCode == 201) {
                  String id = json.decode(response.body)["blog"]["_id"];
                  var imageResponse = await networkHandler.patchImage(
                      "/blogPost/add/coverImage/$id", _imageFile.path);
                  print(imageResponse.statusCode);
                  if (imageResponse.statusCode == 200 ||
                      imageResponse.statusCode == 201) {
                    setState(() {
                      circular = false;
                    });
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName,
                      (route) => false,
                    );
                  } else {
                    setState(() {
                      circular = false;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Could not Upload image',
                        ),
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                    );
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
              }
            } else {
              return;
            }
          },
          child: Center(
              child: circular
                  ? CircularProgressIndicator()
                  : Text(
                      "Add Blog",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Choose Cover photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      currentFocus.focusedChild.unfocus();
                    }
                    takeCoverPhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: Text("Camera"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takeCoverPhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> takeCoverPhoto(ImageSource source) async {
    final coverPhoto = await _picker.getImage(source: source);
    setState(() {
      _imageFile = coverPhoto;
      iconphoto = coverPhoto == null ? Icons.image : Icons.check_box;
    });
  }
}
