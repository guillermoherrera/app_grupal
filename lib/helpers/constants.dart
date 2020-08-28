import 'dart:ui';

class Constants{

  static final String rootPage = '/';
  static final String loginPage = 'login';
  static final String homePage = 'home';

  static final Color primaryColor = Color(0xff76BD21);
  static final Color defaultColor = Color(0xfff2f2f2);

  static final String logo = 'assets/adminconfia.png';

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