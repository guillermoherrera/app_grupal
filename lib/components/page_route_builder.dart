import 'package:app_grupal/pages/confiashop/confiashop_page.dart';
import 'package:app_grupal/pages/drawer/info_page.dart';
import 'package:app_grupal/pages/solicitud/solicitud_page.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_grupo.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones_integrante.dart';
import 'package:app_grupal/pages/root_page.dart';

class CustomRouteTransition{
  
  Route crearRutaSlide(String route, Map<String, dynamic> params, {void Function(int, double) setMonto, void Function(int, String) setTicket, void Function(int, int) setRolGrupo, void Function(int) getNewIntegrante, VoidCallback getLastGrupos, Future<bool> Function() sincroniza}){

    Widget ruta = _getPage(route, params, setMonto, setTicket, setRolGrupo, getNewIntegrante, getLastGrupos, sincroniza);

    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => ruta,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: ( context, animation, sencondaryAnimation, child ) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: Curves.ease);
        if(route == "Constants.renovacionIntegrantePage"){
          return FadeTransition(
            child: child,
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curveAnimation)
          );
        }else if(route == Constants.solicitudPage){
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(curveAnimation),
            child: child,
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

  Widget _getPage(String ruta, Map<String, dynamic> params, void Function(int, double) setMonto, void Function(int, String) setTicket, void Function(int, int) setRolGrupo, void Function(int) getNewIntegrante, VoidCallback getLastGrupos, Future<bool> Function() sincroniza){
    if(ruta == Constants.renovacionGrupoPage){
      return RenovacionesGrupoPage(params: params, getLastGrupos: getLastGrupos, sincroniza: sincroniza);
    }else if(ruta == Constants.renovacionIntegrantePage){
      return RenovacionesIntegrentePage(params: params, setMonto: setMonto, setTicket: setTicket, setRolGrupo: setRolGrupo);
    }else if(ruta == Constants.confiashopPage){
      return ConfiashopPage(params: params, setTicket: setTicket);
    }else if(ruta == Constants.solicitudPage){
      return SolicitudPage(params: params, getNewIntegrante: getNewIntegrante);
    }else if(ruta == Constants.infoPage){
      return InfoPage();
    }
    return RootPage();
  }

}