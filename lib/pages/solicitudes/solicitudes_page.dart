import 'dart:ui';

import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({
    Key key, 
    this.getLastGrupos, 
    this.sincroniza
  }) : super(key: key);

  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;

  @override
  _SolicitudesPageState createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  final _customRoute = CustomRouteTransition();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyContent(), 
    );
  }

  Widget _bodyContent(){
    return Container(
      color: Colors.white,
      child:  _botones()
    );
  }

  Widget _botones(){
    return Table(
      children: [
        TableRow(
          children: [
            _creaBoton(Constants.primaryColor, Icons.group_add, 'Agregar Grupo Nuevo', (){Navigator.push(context, _customRoute.crearRutaSlide(Constants.nuevoGrupoPage, {}, getLastGrupos: widget.getLastGrupos, sincroniza: widget.sincroniza));} ),
          ]
        ),
        TableRow(
          children: [
            _creaBoton(Constants.primaryColor, Icons.group, 'Ver Grupos Creados', (){Navigator.push(context, _customRoute.crearRutaSlide(Constants.gruposPage, {}, getLastGrupos: widget.getLastGrupos, sincroniza: widget.sincroniza));} )
          ]
        ),
        TableRow(
          children: [
            _creaBoton(Constants.primaryColor, Icons.notifications, 'Mensajes', (){Navigator.push(context, _customRoute.crearRutaSlide(Constants.notificacionesPage, {}));}),
          ]
        )
      ],
    );
  }

  Widget _creaBoton(Color color, IconData icono, String texto, VoidCallback action){
    //String heroTag = getHeroTag(texto);
    return GestureDetector(
      onTap: ()=> action(),
      child: Container(
        height: 100.0,
        margin: EdgeInsets.all(10.0),
        width: 180.0,
        decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(20.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      //Hero(tag: heroTag,child: Icon(icono, color: color, size: 40.0)),
                      Icon(icono, color: color, size: 40.0),
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
                Expanded(
                  flex: 1,
                  child: Icon(Icons.arrow_forward_ios, color: color)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getHeroTag(String texto){
    switch (texto) {
      case 'Inicio':
        return 'inicio';
        break;
      case 'Contraseña':
        return 'contraseña';
        break;
      case 'Información':
        return 'info';
        break;
      default:
        return 'logout';
    }
  }
}