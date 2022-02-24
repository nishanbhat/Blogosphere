import 'package:blog_app/blog/updateBlog.dart';
import 'package:blog_app/screen/CommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blog_app/pages/WelcomePage.dart';
import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/SignInPage.dart';
import 'package:blog_app/pages/HomePage.dart';
import 'package:blog_app/screen/HomeScreen.dart';
import 'package:blog_app/profile/ProfileScreen.dart';
import 'package:blog_app/profile/CreateProfile.dart';
import 'package:blog_app/profile/MainProfile.dart';
import 'package:blog_app/pages/LoadingPage.dart';
import 'package:blog_app/profile/EditProfile.dart';
import 'package:blog_app/blog/addBlog.dart';
import 'package:blog_app/screen/UserBlogScreen.dart';
import 'package:blog_app/pages/ForgotPassword.dart';
import 'package:blog_app/screen/BlogScreen.dart';
import 'package:blog_app/widgets/Otp.dart';
import 'package:blog_app/widgets/ResetPassword.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = LoadingPage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await storage.delete(key: "profile");
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   textTheme: GoogleFonts.openSansTextTheme(
        //     Theme.of(context).textTheme,
        //   ),
        //   brightness: Brightness.dark,
        // ),
        home: page,
        routes: {
          SignUpPage.routeName: (ctx) => SignUpPage(),
          SignInPage.routeName: (ctx) => SignInPage(),
          ForgotPassword.routeName: (ctx) => ForgotPassword(),
          UpdateBlog.routeName: (ctx) => UpdateBlog(
                ModalRoute.of(ctx).settings.arguments,
              ),
          Otp.routeName: (ctx) => Otp(
                ModalRoute.of(ctx).settings.arguments,
              ),
          ResetPassword.routeName: (ctx) => ResetPassword(
                ModalRoute.of(ctx).settings.arguments,
              ),
          HomePage.routeName: (ctx) => HomePage(),
          WelcomePage.routeName: (ctx) => WelcomePage(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          CreateProfile.routeName: (ctx) => CreateProfile(),
          EditProfile.routeName: (ctx) => EditProfile(
                ModalRoute.of(ctx).settings.arguments,
              ),
          MainProfile.routeName: (ctx) => MainProfile(),
          AddBlog.routeName: (ctx) => AddBlog(),
          UserBlogScreen.routeName: (ctx) => UserBlogScreen(),
          BlogScreen.routeName: (ctx) => BlogScreen(
                ModalRoute.of(ctx).settings.arguments,
              ),
          CommentScreen.routeName: (ctx) => CommentScreen(
                ModalRoute.of(ctx).settings.arguments,
              )
        },
      ),
    );
  }
}
