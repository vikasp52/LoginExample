import 'package:flutter/material.dart';
import 'package:flutter_assignment/Util/FaceBookSignInUtil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;



import 'HomePage.dart';


class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  bool isLoading = false;

  Future checkFingerprint()async{
    try {
      var localAuth = new LocalAuthentication();
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate yourself');
      
      if(didAuthenticate){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MapPage()));
      }
      // check didAuthenticate and take action
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        print("There is some problem in authondication");
      }
    }

  }

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
              'Click below button to login from facebook or Authondicate your finger print',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            MaterialButton(onPressed: checkFingerprint,
              color: Colors.indigo,
              child: Text("Fingerprint Login", style: TextStyle(
                  color: Colors.white,
                  fontWeight:FontWeight.bold
              ),),),
            
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
