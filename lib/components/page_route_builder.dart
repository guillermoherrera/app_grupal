import 'package:app_grupal/pages/confiashop/confiashop_page.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_grupo.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_integrante.dart';
import 'package:app_grupal/pages/root_page.dart';

class CustomRouteTransition{
  
  Route crearRutaSlide(String route, Map<String, dynamic> params){

    Widget ruta = _getPage(route, params);

    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => ruta,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: ( context, animation, sencondaryAnimation, child ) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: Curves.ease);
        if(route == "Constants.renIntegrante"){
          return FadeTransition(
            child: child,
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curveAnimation)
          );
        }else{
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(curveAnimation),
            child: child,
          );
        }
      },
    );
  }

  Widget _getPage(String ruta, Map<String, dynamic> params){
    if(ruta == Constants.renGrupo){
      return RenovacionesGrupoPage(params: params);
    }else if(ruta == Constants.renIntegrante){
      return RenovacionesIntegrentePage(params: params);
    }else if(ruta == Constants.confiashopPage){
      return ConfiashopPage();
    }
    return RootPage();
  }

}