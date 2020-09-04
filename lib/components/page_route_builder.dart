import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_grupo.dart';
import 'package:app_grupal/pages/root_page.dart';
import 'package:flutter/material.dart';

class CustomRouteTransition{
  
  Route crearRutaSlide(String route, Map<String, dynamic> params){

    Widget ruta = _getPage(route, params);

    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => ruta,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: ( context, animation, sencondaryAnimation, child ) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: Curves.ease);
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(curveAnimation),
          child: child,
        );
      },
    );
  }

  Widget _getPage(String ruta, Map<String, dynamic> params){
    if(ruta == Constants.renGrupo){
      return RenovacionesGrupoPage(params: params);
    }
    return RootPage();
  }

}