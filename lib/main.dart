import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';
 
import 'package:app_grupal/pages/root_page.dart';
import 'package:app_grupal/pages/login/login_page.dart';
import 'package:app_grupal/pages/home/home_page.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asesores App',
      debugShowCheckedModeBanner: false,
      initialRoute: Constants.rootPage,
      routes: {
        Constants.rootPage  : (BuildContext context) => RootPage(),
        Constants.loginPage : (BuildContext context) => LoginPage(),
        Constants.homePage  : (BuildContext context) => HomePage()
      },
    );
  }
}