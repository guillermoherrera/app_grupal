import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/root_page.dart';
import 'package:app_grupal/pages/login/login_page.dart';
import 'package:app_grupal/pages/home/home_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError){
          print("Error FlutterFire");
          print(snapshot);
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.connectionState == ConnectionState.done){
          print("Done FlutterFire");
          return MaterialApp(
            title: 'Asesores App',
            debugShowCheckedModeBanner: false,
            initialRoute: Constants.rootPage,
            theme: ThemeData(
              primaryColor: Constants.primaryColor
            ),
            routes: {
              Constants.rootPage  : (BuildContext context) => RootPage(),
              Constants.loginPage : (BuildContext context) => LoginPage(),
              Constants.homePage  : (BuildContext context) => HomePage()
            },
          );
        }
        
        print("Wait FlutterFire");
        return Container();
      }
    ); 
    
  }
}