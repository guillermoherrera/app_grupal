class Renovacion{
  int idRenovacion;
  int idGrupo;
  String nombreGrupo;
  int noCda;
  String cveCli;
  String nombreCompleto;
  double importe;
  double capital;
  int diasAtraso;
  String beneficio;
  String ticket;
  int status;
  String userID;
  int tipoContrato;
  double nuevoCapital;
  String telefono;
  int presidente;
  int tesorero;

  Renovacion({
    this.beneficio,
    this.capital,
    this.cveCli,
    this.noCda,
    this.diasAtraso,
    this.idGrupo,
    this.idRenovacion,
    this.importe,
    this.nombreCompleto,
    this.nombreGrupo,
    this.ticket,
    this.status,
    this.userID,
    this.tipoContrato,
    this.nuevoCapital,
    this.telefono,
    this.presidente,
    this.tesorero,
  });

  Map<String, dynamic> toJson() => {
    'beneficio'      : beneficio,
    'capital'        : capital,
    'cveCli'         : cveCli,
    'noCda'          : noCda,
    'diasAtraso'     : diasAtraso,
    'idGrupo'        : idGrupo,
    'idRenovacion'   : idRenovacion,
    'importe'        : importe,
    'nombreCompleto' : nombreCompleto,
    'nombreGrupo'    : nombreGrupo,
    'ticket'         : ticket,
    'status'         : status,
    'userID'         : userID,
    'tipoContrato'   : tipoContrato,
    'nuevoCapital'   : nuevoCapital,
    'presidente'     : presidente,
    'tesorero'       : tesorero,
    'telefono'       : telefono
  };

  Renovacion.fromjson(Map<String, dynamic> json){
    this.beneficio      = json['beneficio'];
    this.capital        = json['capital'];
    this.cveCli         = json['cveCli'];
    this.noCda          = json['noCda'];
    this.diasAtraso     = json['diasAtraso'];
    this.idGrupo        = json['idGrupo'];
    this.idRenovacion   = json['idRenovacion'];
    this.importe        = json['importe'];
    this.nombreCompleto = json['nombreCompleto'];
    this.nombreGrupo    = json['nombreGrupo'];
    this.ticket         = json['ticket'];
    this.status         = json['status'];
    this.userID         = json['userID'];
    this.tipoContrato   = json['tipoContrato'];
    this.nuevoCapital   = json['nuevoCapital'];
    this.presidente     = json['presidente'];
    this.tesorero       = json['tesorero'];
    this.telefono       = json['telefono'];
  }
}