import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class CustomSnakBar{
  showSnackBar(String mensaje, Duration duration, Color color, IconData icon, GlobalKey<ScaffoldState> scaffoldKey, {SnackBarAction action}){
    
    final snackBar = SnackBar(
      action: action,
      content: Row(
        //direction: Axis.horizontal,
        children: [
          Icon(icon),
          SizedBox(width: 20.0,),
          Expanded(
            child: Container(
              //width: action == null ? 250 : 200,
              child: Wrap(
                children: [
                  Text(
                    mensaje.toUpperCase(),
                    //overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: duration,
    );
    
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showSnackBarSuccess(String mensaje, Duration duration, Color color, IconData icon, GlobalKey<ScaffoldState> scaffoldKey){
    
    final snackBar = SnackBar(
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) => debugPrint("no can do!"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100),
            SizedBox(width: 20.0,),
            Text(
              mensaje.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: Constants.encabezadoStyle,
            ),
            Text(
              mensaje.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: Constants.subtituloStyle,
            ),
          ],
        ),
      ),
      backgroundColor: color,
      duration: duration,
    );
    
    scaffoldKey.currentState.showSnackBar(snackBar);
  }  
}