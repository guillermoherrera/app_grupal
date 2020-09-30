import 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/models/renovacion_model.dart';

class FirebaseGrupo {
  String nombre;
  int status;
  String userID;
  double capitalTotal;
  int integrantes;
  int contratoId;

  String grupoID;
  
  FirebaseGrupo({
    this.nombre,
    this.status,
    this.capitalTotal,
    this.integrantes,
    this.userID,
    this.contratoId,

    this.grupoID,
  });

  Map<String, dynamic> toJson()=>{
    'nombre'       : nombre,
    'status'       : status,
    'userID'       : userID,
    'capitalTotal' : capitalTotal,
    'integrantes'  : integrantes,
    'contratoId'   : contratoId
  };

  FirebaseGrupo getFirebaseGrupo(Grupo grupo){
    return new FirebaseGrupo(
      nombre       : grupo.nombreGrupo,
      status       : 2,
      userID       : grupo.userID,
      capitalTotal : grupo.importeGrupo,
      integrantes  : grupo.cantidadSolicitudes,
      contratoId   : grupo.contratoId,
      grupoID      : grupo.grupoID 
    );
  }
}

class FirebaseRenovacion{
  int noCda;
  String cveCli;
  String nombre;
  double nuevoCapital;
  double capitalHistorico; 
  int diasAtraso;
  //List<Map> beneficios;
  String grupoID;
  String grupoNombre;
  String ticket;
  int status;
  String userID;
  DateTime fechaCaptura;
  int contratoId;
  int tipoContrato;
  double importeHistorico;

  FirebaseRenovacion({
    this.noCda,
    this.cveCli,
    this.nombre,
    this.nuevoCapital,
    this.capitalHistorico,
    this.diasAtraso,
    //this.beneficios,
    this.grupoID,
    this.grupoNombre,
    this.ticket,
    this.status,
    this.userID,
    this.fechaCaptura,
    this.contratoId,
    this.tipoContrato,
    this.importeHistorico
  });

  Map<String, dynamic> toJson()=>{
    'noCda'            : noCda,
    'cveCli'           : cveCli,
    'nombre'           : nombre,
    'nuevoCapital'     : nuevoCapital,
    'capitalHistorico' : capitalHistorico,
    'diasAtraso'       : diasAtraso,
    //'beneficios'       : beneficios,
    'grupoID'          : grupoID,
    'grupoNombre'      : grupoNombre,
    'ticket'           : ticket,
    'status'           : status,
    'userID'           : userID,
    'fechaCaptura'     : fechaCaptura,
    'contratoId'       : contratoId,
    'tipoContrato'     : tipoContrato,
    'importeHistorico' : importeHistorico
  };

  FirebaseRenovacion getFirebaseRenovacion(Renovacion renovacion, String grupoID, int contratoId){
    return new FirebaseRenovacion(
      noCda: renovacion.noCda,
      cveCli: renovacion.cveCli,
      nombre: renovacion.nombreCompleto,
      nuevoCapital: renovacion.nuevoCapital,
      capitalHistorico: renovacion.capital,
      diasAtraso: renovacion.diasAtraso,
      grupoID: grupoID,
      grupoNombre: renovacion.nombreGrupo,
      ticket: renovacion.ticket,
      status: 1,
      userID: renovacion.userID,
      fechaCaptura: DateTime.now(),
      contratoId: contratoId,
      tipoContrato: 2,
      importeHistorico: renovacion.importe,
    );
  }
}