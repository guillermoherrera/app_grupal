import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/classes/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedActions _sharedActions = SharedActions();
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> sincRegistroInfo = {};
  
  @override
  void initState() {
    _getDrawerInfo();
    super.initState();
  }

  _getDrawerInfo()async{
    //await Future.delayed(Duration(milliseconds: 1000));
    userInfo = await _sharedActions.getUserInfo();
    sincRegistroInfo = await _sharedActions.getSincRegistroInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    
    return SizedBox(
      width: _width * 1.0,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent
        ),
        child: Drawer(
          child: Column(
            children: _menu(_height, context)
            ,
          ),
        )
      ),
    );
  }

  List<Widget> _menu(double height, BuildContext context){
    return [
      _info(height),
      _opciones(context),
      _sinInfo()
    ];
  }

  Widget _info(double height){
    List<Widget> childrens = [
      Container(
        child: Icon(
          Icons.person,
          color: Constants.primaryColor,
          size: 100,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
      ),
      SizedBox(height: height / 40),
      userInfo['name'] == null ? Container() : CustomFadeTransition(
        child: Center(
          child: Text(
            '${userInfo['name']}'.toUpperCase(),
            style: Constants.encabezadoStyle,
          )
        ),
      ),
      userInfo['name'] == null ? Container() : CustomFadeTransition(
        child: Center(
          child: Text(
            '${userInfo['user']} | ${userInfo['sistemaDesc']}'.toUpperCase(),
            style: Constants.subtituloStyle,
          )
        ),
      )
    ];
        
    return Container(
      height: height / 2.5,
      color: Constants.primaryColor.withOpacity(0.8),
      //decoration: BoxDecoration(
      //  gradient: LinearGradient(
      //    begin: FractionalOffset(1.0, 0.0),
      //    end: FractionalOffset(0.01, 0.0),
      //    colors: [Color.fromRGBO(118, 189, 33, 1.0).withOpacity(0.8), Color.fromRGBO(98, 169, 13, 1.0).withOpacity(0.8)]
      //  )
      //),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: childrens,
      ),
    );
  }

  Widget _opciones(BuildContext context){
    return Expanded(
      child: Container(
        color: Colors.white.withOpacity(0.8),
        child: ListView(
          children: [
            _botones(context)
          ],
        ) 
      ),
    );
  }

  Widget _botones(BuildContext context){
    return Table(
      children: [
        TableRow(
          children: [
            ShakeTransition(duration: Duration(milliseconds: 3000), child: _creaBoton(Constants.primaryColor, Icons.home, 'Inicio', ()=>_actions(context, 0) )),
            ShakeTransition(duration: Duration(milliseconds: 1500),child: _creaBoton(Constants.primaryColor, Icons.lock, 'Contraseña', ()=>_actions(context, 1)))
          ]
        ),
        TableRow(
          children: [
            ShakeTransition(duration: Duration(milliseconds: 4000),child: _creaBoton(Constants.primaryColor, Icons.info, 'Información', ()=>_actions(context, 2))),
            ShakeTransition(duration: Duration(milliseconds: 2000),child: _creaBoton(Constants.primaryColor, Icons.exit_to_app, 'Cerrar Sesión', ()=>_actions(context, 3)))
          ]
        )
      ],
    );
  }

  Widget _creaBoton(Color color, IconData icono, String texto, VoidCallback action){
    //String heroTag = getHeroTag(icono.codePoint);
    return GestureDetector(
      onTap: ()=> action(),
      child: Container(
        height: 180.0,
        margin: EdgeInsets.all(15.0),
        width: 180.0,
        decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(20.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                CircleAvatar(
                  backgroundColor: color,
                  radius: 40.0,
                  child: Icon(icono, color: Colors.white, size: 30.0),
                ),
                Text(
                  texto.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color, fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sinInfo(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      color: Colors.white.withOpacity(0.8),
      child: sincRegistroInfo['horaSincronizacion'] == null ? Container() : CustomFadeTransition(
        child: Text(
          "Ultima Sincronización: ${sincRegistroInfo['horaSincronizacion']}".toUpperCase(),
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
  }

  _actions(BuildContext context, action) async{
    final AuthFirebase _authFirebase = new AuthFirebase();
    final SharedActions _sharedActions = new SharedActions();
    
    switch (action) {
      case 1:
        Navigator.pop(context);
        break;
      case 2:
        Navigator.pop(context);
        break;
      case 3:
        await _authFirebase.signOut();
        _sharedActions.clear();
        Navigator.pushReplacementNamed(context, Constants.loginPage, arguments: true);
        break;
      default:
        Navigator.pop(context);
    }
  }
}