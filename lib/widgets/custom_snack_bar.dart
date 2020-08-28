import 'package:flutter/material.dart';

class CustomSnakBar{
  showSnackBar(String mensaje, Duration duration, Color color, IconData icon, GlobalKey<ScaffoldState> scaffoldKey){
    
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon),
          SizedBox(width: 20.0,),
          Text(
            mensaje,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: duration,
    );
    
    scaffoldKey.currentState.showSnackBar(snackBar);
  }  
}