import 'package:blog_client/pages/signup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> animation1;

  late AnimationController _controller2;
  late Animation<Offset> animation2;

  @override
  void initState() {
    
    super.initState();

    //animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(1.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

    //animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );
    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
  }

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
              SlideTransition(
                position: animation1,
                child: const Text(
                  "BLOG APP",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              SlideTransition(
                position: animation1,
                child: const Text(
                  "A Way to Inspire...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: 2),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SlideTransition(
                position: animation1,
                child: const Text(
                  "Empower..",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: 2),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SlideTransition(
                position: animation1,
                child: const Text(
                  "and Educate The World ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: 2),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              boxContainer("assets/google.png", "Sign up with Google",null),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/fb.png", "Sign up with Facebook",null),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/email.jpg", "Sign up with Email",onEmailClick()),
              SizedBox(
                height: 30,
              ),
              SlideTransition(
                position: animation2,
                child: Row(
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
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }

  Widget boxContainer(String path, String text, onClick) => SlideTransition(
        position: animation2,
        child: InkWell(
          onTap: onClick,
          child: SizedBox(
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
          ),
        ),
      );
}
