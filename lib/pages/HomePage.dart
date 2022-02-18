import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/models/ProfileModel.dart';
import 'package:blog_app/blog/addBlog.dart';
import 'package:blog_app/pages/WelcomePage.dart';
import 'package:blog_app/screen/HomeScreen.dart';
import 'package:blog_app/profile/ProfileScreen.dart';
import 'package:blog_app/screen/UserBlogScreen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  String username = "";
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read("profile");
    _read("username");
    getProfile();
  }

  void getProfile() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data1 = await _read("profile");
      final data2 = await _read("username");
      if (data1 != null) {
        setState(() {
          username = data2;
          profilePhoto = CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              ProfileModel.fromJson(
                json.decode(data1),
              ).img.url,
            ),
          );
        });
      } else {
        checkProfile();
      }
    });
  }

  void checkProfile() async {
    final data2 = await _read("username");
    var response = await networkHandler.get("/profile/checkProfile");
    if (response == null) {
      setState(() {
        username = data2;
      });
    } else if (response["Status"] == true) {
      setState(() {
        username = data2;
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            response['img'],
          ),
        );
      });
    } else {
      setState(() {
        username = data2;
      });
    }
  }

  dynamic _read(String key1) async {
    // await storage.delete(key: "profile");
    String profile = await storage.read(key: key1);
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          titleString[currentState],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text("@$username"),
                ],
              ),
            ),
            ListTile(
              title: Text("All Blogs"),
              trailing: Icon(Icons.launch),
              onTap: () {
                Navigator.of(context).pushNamed(
                  HomePage.routeName,
                );
              },
            ),
            ListTile(
              title: Text("New Blog"),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AddBlog.routeName,
                );
              },
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("My Blogs"),
              trailing: Icon(Icons.book),
              onTap: () {
                Navigator.of(context).pushNamed(
                  UserBlogScreen.routeName,
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        // height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Are you sure you want to logout?",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await storage.deleteAll();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          WelcomePage.routeName,
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                // await storage.deleteAll();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   WelcomePage.routeName,
                //   (route) => false,
                // );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddBlog.routeName,
          );
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );
}
