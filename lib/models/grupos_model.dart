class Grupo{

  int idGrupo;
  String nombreGrupo;
  int status;
  String userID;
  double importeGrupo;
  int cantidadSolicitudes;
  String grupoID;
  int contratoId;

  Grupo({
    this.idGrupo,
    this.nombreGrupo,
    this.status,
    this.userID,
    this.cantidadSolicitudes,
    this.importeGrupo,
    this.grupoID,
    this.contratoId
  });

  Map<String, dynamic> toJson() =>{
    'idGrupo'             : idGrupo,
    'nombreGrupo'         : nombreGrupo,
    'status'              : status,
    'userID'              : userID,
    'cantidadSolicitudes' : cantidadSolicitudes,
    'importeGrupo'        : importeGrupo,
    'grupoID'             : grupoID,
    'contratoId'          : contratoId
  };

  Grupo.fromjson(Map<String, dynamic> json){
    this.idGrupo             = json['idGrupo'];
    this.nombreGrupo         = json['nombreGrupo'];
    this.status              = json['status'];
    this.userID              = json['userID'];
    this.cantidadSolicitudes = json['cantidadSolicitudes'];
    this.importeGrupo        = json['importeGrupo'];
    this.grupoID             = json['grupoID'];
    this.contratoId          = json['contratoId'];
  }
}