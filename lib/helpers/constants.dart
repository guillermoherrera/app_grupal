import 'dart:ui';
import 'package:flutter/material.dart';

class Constants{

  static final String rootPage = '/';
  static final String loginPage = 'login';
  static final String homePage = 'home';
  static final String renGrupo = 'renovacionGrupo';
  static final String renIntegrante = 'renovacionIntegrante';
  static final String confiashopPage = 'confiashop';

  static final Color primaryColor = Color(0xff76BD21);
  static final Color defaultColor = Color(0xfff2f2f2);

  static final String logo = 'assets/adminconfia.png';
  static final String homeImage = 'assets/analysis.png';
  static final String emptyImage = 'assets/empty.png';
  static final String confiashop = 'assets/confiashop.png';

  static final String baseURL = 'test.api.asesores.fconfia.com';
  static final String apiKey = 'doCLjcd9FIABAzXhF49AMDTPJqo608M5Wau';
  static final String consultaContratos = 'contratosAsesor';
  static final String consultaIntegrantes = 'contratoDetalle';

  static final String homeText = 'Puedes comenzar a capturar nuevas solicitudes de crédito grupal o revisar la información de los grupos con los que ya estas trabajando, solo ve a la barra de navegación inferior y selecciona la opción que necesites.';

  static final TextStyle encabezadoStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);
  static final TextStyle subtituloStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white70);
  static final TextStyle mensajeCentral = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey[600]);
  static final TextStyle mensajeCentral2 = TextStyle(fontSize: 11.0, color: Colors.grey);
  static final TextStyle mensajeCentral3 = TextStyle(fontSize: 11.0);
  static final TextStyle mensajeCentralNot = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey);
  static final TextStyle mensajeCentralNotMedium = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey);
  static final TextStyle mensajeMonto = TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0);

  static String errorAuth(error){
    if(error.contains("invalid-email")){
      return "El formato del correo no es correcto.";
    }else if(error.contains("Given String is empty or null")){
      return "Es necesario llenar los campos de correo y contraseña para iniciar sesión.";
    }else if(error.contains("ERROR_TOO_MANY_REQUESTS")){
      return "ATENCIÓN: Has intentado iniciar sesión demasiadas veces, intentalo de nuevo mas tarde o ponte en contacto con soporte.";
    }else if(error.contains("An internal error has occurred. [ 7: ]")){
      return "Error interno, revisa tu conexión a internet.";
    }else if(error.contains("TimeoutException")){
      return "Error interno, revisa tu conexión a internet.";
    }else if(error.contains("ERROR_NETWORK")){
      return "Error interno, revisa tu conexión a internet.";
    }else{
      return "Correo y/o contraseña incorrectos.";
    }
  }
}