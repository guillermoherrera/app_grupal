import 'package:app_grupal/models/documentos_model.dart';
import 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/models/renovacion_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';

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

class FirebaseSolicitud{
  Map persona;
  Map direccion;
  double importeCapital;
  DateTime fechaCaptura;
  int tipoContrato; 
  String userID;
  List<Map> documentos;
  int status;

  String grupoNombre;
  int contratoId;
  String grupoID;
  //int grupo_Id;

  FirebaseSolicitud({
    this.persona,
    this.direccion,
    this.importeCapital,
    this.fechaCaptura,
    this.tipoContrato,
    this.userID,
    this.documentos,
    this.status,
    this.contratoId,
    this.grupoNombre,
    this.grupoID,
    //this.grupo_Id
  });

  Map<String, dynamic> toJson()=>{
    'persona'        : persona,
    'direccion'      : direccion,
    'importeCapital' : importeCapital,
    'fechaCaptura'   : fechaCaptura,
    'tipoContrato'   : tipoContrato,
    'userID'         : userID,
    'documentos'     : documentos,
    'status'         : status,
    'grupoNombre'    : grupoNombre,
    'grupoID'        : grupoID,
    'contratoId'     : contratoId
  };

  FirebaseSolicitud getFirebaseSolicitud(Solicitud solicitud, Map persona, Map direccion, List<Documento> documentos, String grupoID){
    return new FirebaseSolicitud(
      persona: persona,
      direccion: direccion,
      importeCapital: solicitud.capital,
      fechaCaptura: DateTime.fromMillisecondsSinceEpoch(solicitud.fechaNacimiento).toUtc(),
      tipoContrato: 2,
      userID: solicitud.userID,
      documentos: documentos.map((e) => e.toJson()).toList(),
      status: 1,
      grupoNombre: solicitud.nombreGrupo, 
      grupoID: grupoID
    );
  }
}

class FirebasePersona{
  String nombre;
  String segundoNombre;
  String apellido;
  String segundoApellido;
  DateTime fechaNacimiento;
  String curp;
  String rfc;
  String telefono;

  FirebasePersona({
    this.nombre,
    this.apellido,
    this.segundoApellido,
    this.curp,
    this.fechaNacimiento,
    this.segundoNombre,
    this.rfc,
    this.telefono
  });

  Map<String, dynamic> toJson()=>{
    'nombre'          : nombre,
    'apellido'        : apellido,
    'segundoApellido' : segundoApellido,
    'curp'            : curp,
    'fechaNacimiento' : fechaNacimiento,
    'segundoNombre'   : segundoNombre,
    'rfc'             : rfc,
    'telefono'        : telefono
  };

  FirebasePersona getFirebasePersona(Solicitud solicitud){
    return new FirebasePersona(
      nombre: solicitud.nombre,
      segundoNombre: solicitud.segundoNombre,
      apellido: solicitud.segundoNombre,
      segundoApellido: solicitud.segundoApellido,
      curp: solicitud.curp,
      fechaNacimiento: DateTime.fromMillisecondsSinceEpoch(solicitud.fechaNacimiento).toUtc(),
      rfc: solicitud.rfc,
      telefono: solicitud.telefono,
    );
  }
}

class FirebaseDireccion{
  String direccion1;
  String coloniaPoblacion;
  String delegacionMunicipio;
  String ciudad;
  String estado;
  int cp;
  String pais;

  FirebaseDireccion({
    this.ciudad,
    this.coloniaPoblacion,
    this.cp,
    this.delegacionMunicipio,
    this.direccion1,
    this.estado,
    this.pais
  });

  Map<String, dynamic> toJson()=>{
    'ciudad'              : ciudad,
    'coloniaPoblacion'    : coloniaPoblacion,
    'cp'                  : cp,
    'delegacionMunicipio' : delegacionMunicipio,
    'direccion1'          : direccion1,
    'estado'              : estado,
    'pais'                : pais
  };

  FirebaseDireccion getFirebaseDireccion(Solicitud solicitud){
    return new FirebaseDireccion(
      ciudad: solicitud.ciudad ,
      coloniaPoblacion: solicitud.coloniaPoblacion ,
      cp: solicitud.cp ,
      delegacionMunicipio: solicitud.delegacionMunicipio ,
      direccion1: solicitud.direccion1 ,
      estado: solicitud.estado ,
      pais: solicitud.pais ,
    );
  }
}
