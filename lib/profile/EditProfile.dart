import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:blog_app/models/ProfileModel.dart';
import 'package:blog_app/pages/HomePage.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit-profile';
  ProfileModel profileModel = ProfileModel();

  EditProfile(
    this.profileModel,
  );

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _name.text = widget.profileModel.name;
      _profession.text = widget.profileModel.profession;
      _dob.text = widget.profileModel.dOB;
      _title.text = widget.profileModel.titleline;
      _about.text = widget.profileModel.about;
    });
  }

  final networkHandler = NetworkHandler();
  bool circular = false;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateFormat("dd/MM/yyyy").parse(_dob.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dob.text = "${DateFormat('dd/MM/yyyy').format(pickedDate)}";
        // _dob.text = "${DateFormat.yMd().format(_selectedDate)}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            professionTextField(),
            SizedBox(
              height: 20,
            ),
            dobTextField(),
            SizedBox(
              height: 20,
            ),
            titleTextField(),
            SizedBox(
              height: 20,
            ),
            aboutTextField(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    if (_globalkey.currentState.validate()) {
                      Map<String, String> data = {
                        "name": _name.text,
                        "profession": _profession.text,
                        "DOB": _dob.text,
                        "titleline": _title.text,
                        "about": _about.text,
                      };
                      var response =
                          await networkHandler.patch("/profile/update", data);
                      if (response == null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Network Error. Please try later',
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                        setState(() {
                          circular = false;
                        });
                      } else if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        // print("start");
                        // print(response.body);
                        // print("end");
                        await storage.write(
                          key: "profile",
                          value: json.encode(
                            ProfileModel.fromJson(
                              json.decode(
                                response.body,
                              )["data"],
                            ),
                          ),
                        );
                        if (_imageFile != null) {
                          var imageResponse = await networkHandler.patchImage(
                              "/profile/add/image", _imageFile.path);
                          if (imageResponse.statusCode == 200) {
                            await storage.write(
                              key: "profile",
                              value: json.encode(
                                ProfileModel.fromJson(
                                  json.decode(
                                    await imageResponse.stream.bytesToString(),
                                  )["data"],
                                ),
                              ),
                            );
                            setState(() {
                              circular = false;
                            });
                            Navigator.of(context).pushReplacementNamed(
                              HomePage.routeName,
                            );
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Image couldn\'t be updated',
                                ),
                                duration: Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                            setState(() {
                              circular = false;
                            });
                          }
                        } else {
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushReplacementNamed(
                            HomePage.routeName,
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Something went wrong',
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                        setState(() {
                          circular = false;
                        });
                      }
                    }
                  },
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundColor: Colors.white,
          backgroundImage: _imageFile == null
              ? NetworkImage(widget.profileModel.img.url)
              : FileImage(
                  File(_imageFile.path),
                ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
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
              "Choose Profile photo",
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
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: Text("Camera"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
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

  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person_outline,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        // hintText: "Your Name",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value.isEmpty) return "Profession can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.work_outline,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        // hintText: "Your Profession",
      ),
    );
  }

  Widget dobTextField() {
    return InkWell(
      onTap: _presentDatePicker,
      child: IgnorePointer(
        child: TextFormField(
          controller: _dob,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value.isEmpty) return "DOB can't be empty";
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.date_range,
              color: Colors.green,
            ),
            labelText: "Date of Birth",
            helperText: "Provide DOB on dd/mm/yyyy",
            // hintText: "Your Date of Birth",
          ),
        ),
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value.isEmpty) return "Title can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.work_outline_outlined,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "Title can't be empty",
        // hintText: "Your Title",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value.isEmpty) return "About can't be empty";
        return null;
      },
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        // prefixIcon: Icon(
        //   Icons.info_outline,
        //   color: Colors.green,
        // ),
        labelText: "About",
        helperText: "Write about yourself",
        // hintText: "Your information",
      ),
    );
  }
}
