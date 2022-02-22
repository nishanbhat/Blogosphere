import 'package:flutter/material.dart';

import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/SignInPage.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/welcome-page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLogin = false;
  Map data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0), //(x1,y1)
      end: Offset(0.0, 0.0), //(x2,y2)
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

    //animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0), //(x1,y1)
      end: Offset(0.0, 0.0), //(x2,y2)
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // alignment: Alignment.center,
          height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pic1.jpg"), fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.purple[300]],
            //   begin: const FractionalOffset(0.0, 1.0),
            //   end: const FractionalOffset(0.0, 1.0),
            //   stops: [0.0, 1.0],
            //   tileMode: TileMode.repeated,
            // ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
            child: Column(
              children: [
                SlideTransition(
                  position: animation1,
                  child: Text(
                    "Blogosphere",
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.teal[100],
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text(
                    "A way to Inspire",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: 2,
                      color: Colors.teal[100],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text(
                    "Empower",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.teal[100],
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text(
                    "and",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.teal[100],
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text(
                    "Educate The World!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.teal[100],
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                ),
                boxContainer(
                    "assets/email2.png", "Sign Up with Email", onEmailClick),
                SizedBox(
                  height: 30,
                ),
                SlideTransition(
                  position: animation2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.amberAccent[700],
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(SignInPage.routeName);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.red[50],
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onEmailClick() {
    Navigator.of(context).pushNamed(SignUpPage.routeName);
  }

  Widget boxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * (0.8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  Image.asset(
                    path,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
