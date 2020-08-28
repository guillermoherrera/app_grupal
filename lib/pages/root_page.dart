import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/pages/home/home_page.dart';
import 'package:app_grupal/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage> {
  final AuthFirebase _authFirebase = new AuthFirebase();
  AuthStatus authStatus = AuthStatus.notSignedIn;
  
  @override
  void initState() {
    _authFirebase.currentUser().then((userId){
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(onSignIn: ()=>_updateAuth(AuthStatus.signedIn));
        break;
      case AuthStatus.signedIn:
        return HomePage(onSignIOut: ()=>_updateAuth(AuthStatus.notSignedIn));
        break;
      default:
        return Container();
    }
  }

  void _updateAuth(AuthStatus authStatusUpdate){
    setState(() {
      authStatus = authStatusUpdate;
    });
  }
}