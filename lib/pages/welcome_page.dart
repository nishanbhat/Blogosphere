import 'package:blog_client/main.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.yellowAccent],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: Column(
            children: [
              const Text(
                "BLOG APP",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              const Text(
                "A Way to Inspire...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 5,
              ),
              const Text(
                "Empower..",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    letterSpacing: 2),
              ),
               SizedBox(
                height: 5,
              ),
              const Text(
                "and Educate The World ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 50,
              ),
              boxContainer("assets/google.png", "Sign up with Google"),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/fb.png", "Sign up with Facebook"),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/email.jpg", "Sign up with Email"),
              SizedBox(
                    height: 30,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "SignIN",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget boxContainer(String path, String text) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width - 140,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Image.asset(
              path,
              height: 20,
              width: 20,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
