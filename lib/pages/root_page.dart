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
  AuthStatus authStatus = AuthStatus.notSignedIn;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage();
        break;
      case AuthStatus.signedIn:
        return HomePage();
        break;
    }
  }

  void _updateAuth(AuthStatus authStatusUpdate){
    setState(() {
      authStatus = authStatusUpdate;
    });
  }
}