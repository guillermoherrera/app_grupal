import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/helpers/constants.dart';
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
  bool cargando = true;
  
  @override
  void initState() {
    _authFirebase.currentUser().then((userId)async{
      //await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        cargando = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(cargando) return _loadApp();
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

  Widget _loadApp(){
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        child: Center(child: Text('Asesores App'.toUpperCase(), style: Constants.encabezadoStyle))
      )
    );
  }

  void _updateAuth(AuthStatus authStatusUpdate){
    setState(() {
      authStatus = authStatusUpdate;
    });
  }
}