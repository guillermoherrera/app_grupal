import 'package:app_grupal/pages/drawer/info_page.dart';
import 'package:app_grupal/pages/drawer/paswword_page.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_grupo.dart';
import 'package:app_grupal/pages/solicitudes/integrante.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
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
              Constants.homePage  : (BuildContext context) => HomePage(),
              Constants.renovacionGrupoPage  : (BuildContext context) => RenovacionesGrupoPage(params: null),
              Constants.infoPage : (BuildContext context) => InfoPage(),
              Constants.passwordPage : (BuildContext context) => PasswordPage(),
              Constants.integrantePage: (BuildContext context) => IntegrantePage(),
            },
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
                const Locale('en'), // English
                const Locale('es'), // Español
                const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
                // ... other locales the app supports
            ],
          );
        }
        
        print("Wait FlutterFire");
        return Container();
      }
    ); 
    
  }
}