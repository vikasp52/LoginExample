import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/UI/LoginPage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show PlatformException;

class FaceBookSignInUtil {
  static FirebaseAuth _auth;
  static FacebookLogin _facebookLogin;

  FaceBookSignInUtil() {
    _auth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> signInWithFacebook(BuildContext context) async {
    try {
      _facebookLogin = new FacebookLogin();
      FacebookLoginResult result = await _facebookLogin.logInWithReadPermissions(['email']);
      print(result.status);
      print(result.errorMessage);
      print(result.accessToken.toString());
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          String accessToken = (await _facebookLogin.currentAccessToken).token;
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: accessToken,
          );
          final FirebaseUser user = await _auth.signInWithCredential(credential);
          return user;
        case FacebookLoginStatus.cancelledByUser:
          return null;
          break;
        case FacebookLoginStatus.error:
          return null;
      }
    } on PlatformException catch (e) {
      print("FACEBOOK LOGIN ERR");
      print("e.code: ${e.code}");
      print(e.details);
      print(e.message);
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<bool> signOutFromFacebook(BuildContext context) async {
    try {
      if (_auth != null && _facebookLogin != null) {
        await _auth.signOut();
        await _facebookLogin.logOut().then((_){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MyLoginPage()));
        });
        return Future.value(true);
      } else
        return Future.value(false);
    } catch (e) {
      return Future.value(false);
    }
  }
}
