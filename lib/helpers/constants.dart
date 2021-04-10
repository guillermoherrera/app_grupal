import 'dart:ui';
import 'package:flutter/material.dart';

class Constants{

  static final String rootPage = '/';
  static final String loginPage = 'login';
  static final String homePage = 'home';
  static final String renovacionGrupoPage = 'renovacionGrupo';
  static final String renovacionIntegrantePage = 'renovacionIntegrante';
  static final String confiashopPage = 'confiashop';
  static final String solicitudPage = 'solicitud';
  static final String infoPage = 'infoPage';
  static final String passwordPage = 'paswwordPage';
  static final String carteraGrupoPage = 'carteraGrupoPage';
  static final String carteraIntegrantePage = 'carteraIntegrantePage';
  static final String nuevoGrupoPage = 'nuevoGrupoPage';
  static final String gruposPage = 'gruposPage';
  static final String notificacionesPage = 'notificacionesPage';
  static final String grupoPage = 'grupoPage';
  static final String integrantePage = 'integrantePage';
  static final String pedidoPage = 'pedidoPage';

  static final Color primaryColor = Color(0xff76BD21);
  static final Color defaultColor = Color(0xfff2f2f2);

  static final String logo = 'assets/adminconfia.png';
  static final String homeImage = 'assets/analysis.png';
  static final String emptyImage = 'assets/empty.png';
  static final String confiashop = 'assets/confiashop.png';
  static final String confirmation = 'assets/confirmation.png';
  static final String notImage = 'assets/noImage.png';

  static final String baseURL = /*'vcapi.finconfia.com.mx';*/'192.168.63.60';//'test.api.asesores.fconfia.com';
  static final String apiKey = 'doCLjcd9FIABAzXhF49AMDTPJqo608M5Wau';
  static final String consultaContratos = 'contratosAsesor';
  static final String consultaIntegrantes = 'contratoDetalle';
  static final String creditoDetalle = 'creditoDetalle';

  static final String versionApp = "1.0";
  static final String homeText = 'Puedes comenzar a capturar nuevas solicitudes de crédito grupal o revisar la información de los grupos con los que ya estas trabajando, solo ve a la barra de navegación inferior y selecciona la opción que necesites.';
  static final String info1 = 'Aplicación desarrollada para operar como una herramienta de trabajo en apoyo a la operación de los asesores de créditos grupales. ';
  static final String info2 = '''La principal función de esta app es la de facilitar y validar la captura de solicitudes de crédito para agilizar el proceso de originación y mejorar la calidad del servicio. Algunas de las características principales que se encuentran en la app son:
    \n * Renovaciones.
  * Captura de nuevos integrantes.
  * Seguimiento de solicitudes.
  * Revición de cartera.
  * ConfiaShop.''';

  static final TextStyle encabezadoStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);
  static final TextStyle subtituloStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white70);
  static final TextStyle subtituloStyle2 = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white);
  static final TextStyle mensajeCentral = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey[600]);
  static final TextStyle mensajeCentral2 = TextStyle(fontSize: 11.0, color: Colors.grey);
  static final TextStyle mensajeCentral2bold = TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.bold);
  static final TextStyle mensajeCentral2error = TextStyle(fontSize: 11.0, color: Colors.red);
  static final TextStyle mensajeCentral3 = TextStyle(fontSize: 11.0);
  static final TextStyle mensajeCentralNot = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey[300], decoration: TextDecoration.lineThrough);
  static final TextStyle mensajeCentralNotMedium = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.grey);
  static final TextStyle mensajeMonto = TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0);
  static final TextStyle mensajeInfo = TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white);
  static final TextStyle mensajeMonto2 = TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.grey[400]);
  static final TextStyle mensajeMonto3 = TextStyle(fontSize: 22,fontWeight: FontWeight.bold);

  static String errorAuth(error){
    if(error.contains("invalid-email")){
      return "El formato del usuario no es correcto.";
    }else if(error.contains("Given String is empty or null")){
      return "Es necesario llenar los campos de usuario y contraseña para iniciar sesión.";
    }else if(error.contains("ERROR_TOO_MANY_REQUESTS")){
      return "ATENCIÓN: Has intentado iniciar sesión demasiadas veces, intentalo de nuevo mas tarde o ponte en contacto con soporte.";
    }else if(error.contains("An internal error has occurred. [ 7: ]")){
      return "Error desconocido, revisa tu conexión a internet.";
    }else if(error.contains("TimeoutException")){
      return "Timeout: Tiempo de espera agotado para la solicitud, revisa tu conexión a internet o vulve a intentarlo mas tarde.";
    }else if(error.contains("ERROR_NETWORK") || error.contains("network")){
      return "Error desconocido, revisa tu conexión a internet.";
    }else if(error.contains("Error al iniciar") || error.contains("network")){
      return error;
    }else if(error.contains("Connection failed") || error.contains("network")){
      return "Error de conexión, revisa tu conexión a internet.";
    }else if(error.contains("Future not completed") || error.contains("network")){
      return "Tiempo de espera agotado para el servidor, revisa tu conexión a internet.";
    }else if(error.contains("startIndex ") || error.contains("network")){
      return "Los datos capturados no son correctos.";
    }else if(error.contains("CODIGO") || error.contains("network")){
      return error;
    }else if(error.contains("Unauthorized")){
      return '$error: Por favor vuelva a iniciar sesión para continuar';
    }else{
      return "Ha ocurrido un Error no esperado: $error.";
    }
  }

  //SQFLITE
  //catalogo documentos
  static const catDocumentosTable = 'catDocumentos';
  static const tipo = 'tipo';
  static const descDocumento = 'descDocumento';

  //catalogo integrantes
  static const catIntegrantesTable = 'catIntegrantes';
  static const cantidadIntegrantes = 'cantidadIntegrantes';

  //catalogo estados
  static const catEstadosTable = 'catEstados';
  static const codigo = 'codigo';

  //solicitudes (integrante)
  static const solicitudesTable = 'solicitudes';
  static const idSolicitud = 'idSolicitud'; //documentos
  static const idGrupo = 'idGrupo'; //grupos
  static const nombreGrupo = 'nombreGrupo'; //grupos
  static const importe = 'importe'; //renovaciones
  static const nombre = 'nombre';
  static const segundoNombre = 'segundoNombre';
  static const primerApellido = 'primerApellido';
  static const segundoApellido = 'segundoApellido';
  static const fechaNacimiento = 'fechaNacimiento';
  static const fechaCaptura = 'fechaCaptura';
  static const curp = 'curp';
  static const rfc = 'rfc';
  static const telefono = 'telefono';
  static const tipoContrato = 'tipoContrato'; //renovaciones
  static const documentID = 'documentID';
  static const direccion1 = 'direccion1';
  static const coloniaPoblacion = 'coloniaPoblacion';
  static const delegacionMunicipio = 'delegacionMunicipio';
  static const ciudad = 'ciudad';
  static const estado = 'estado'; //catalogo estados
  static const cp = 'cp';
  static const pais = 'pais';
  static const presidente = 'presidente';
  static const tesorero = 'tesorero';

  //documentos solicitudes (integrante)
  static const documentoSolicitudesTable = 'documentosSolicitudes';
  static const idDocumentoSolicitudes = 'idDocumentoSolicitudes';
  static const tipoDocumento = 'tipoDocumento';
  static const documento = 'documento';
  static const version = 'version';
  static const cambioDoc = 'cambioDoc';
  static const observacionCambio = 'observacionCambio';

  //grupos
  static const gruposTable = 'grupos';
  static const importeGrupo = 'importeGrupo';
  static const cantidadSolicitudes = 'cantidadSolicitudes';
  static const grupoID = 'grupoID';
  static const contratoId = 'contratoId';

  //renovaciones (integrante)
  static const renovacionesTable = "renovaciones";
  static const idRenovacion = "idRenovacion";
  static const noCda = "noCda";
  static const cveCli = "cveCli";
  static const nombreCompleto = "nombreCompleto";
  static const capital = "capital";
  static const diasAtraso = "diasAtraso";
  static const beneficio = "beneficio";
  static const ticket = "ticket";
  static const capitalSolicitado = "capitalSolicitado";
  static const status = 'status';
  static const userID = 'userID';
}