import 'package:flutter/material.dart';
import 'package:flutter_assignment/Util/FaceBookSignInUtil.dart';

import 'HomePage.dart';


class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Login"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click below button to login from facebook',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            MaterialButton(
                color: Colors.black,
                child: Text("Facebook Login", style: TextStyle(
                    color: Colors.white,
                    fontWeight:FontWeight.bold
                ),),
                onPressed: () {
                  FaceBookSignInUtil().signInWithFacebook(context).then(
                        (fireBaseUser) async {
                      setState(() {
                        isLoading = true;
                      });
                      print("FB fireBaseUser: $fireBaseUser");
                      print(fireBaseUser != null);
                      if (fireBaseUser != null) {
                        print("Navigate to home");
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MapPage()));
                      } else {
                        print("Do Not Navigate to home");
                      }
                    },
                  ).catchError((e) {
                    debugPrint(e.toString());
                  });
                }),

            isLoading?CircularProgressIndicator():SizedBox(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
