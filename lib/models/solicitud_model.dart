class Solicitud{

  int idSolicitud;
  int idGrupo;
  String nombreGrupo;
  double capital;
  String nombre;
  String segundoNombre;
  String primerApellido;
  String segundoApellido;
  String fechaNacimiento;
  String curp;
  String rfc;
  String telefono;
  int status;
  int tipoContrato;
  String userID;
  String documentID;
  int presidente;
  int tesorero;
  String direccion1;
  String coloniaPoblacion;
  String delegacionMunicipio;
  String ciudad;
  String estado;
  int cp;
  String pais;
  String fechaCaptura;
  int contratoId;

  Solicitud({
    this.idSolicitud,
    this.idGrupo,
    this.nombreGrupo,
    this.capital,
    this.nombre,
    this.segundoNombre,
    this.primerApellido,
    this.segundoApellido,
    this.fechaNacimiento,
    this.curp,
    this.rfc,
    this.telefono,
    this.status,
    this.tipoContrato,
    this.userID,
    this.documentID,
    this.presidente,
    this.tesorero,
    this.direccion1,
    this.coloniaPoblacion,
    this.delegacionMunicipio,
    this.ciudad,
    this.estado,
    this.cp,
    this.pais,
    this.fechaCaptura,
    this.contratoId
  });

  Map<String, dynamic> toJson() =>{
    'idSolicitud'         : idSolicitud,
    'idGrupo'             : idGrupo,
    'nombreGrupo'         : nombreGrupo,
    'capital'             : capital,
    'nombre'              : nombre,
    'segundoNombre'       : segundoNombre,
    'primerApellido'      : primerApellido,
    'segundoApellido'     : segundoApellido,
    'fechaNacimiento'     : fechaNacimiento,
    'curp'                : curp,
    'rfc'                 : rfc,
    'telefono'            : telefono,
    'status'              : status,
    'tipoContrato'        : tipoContrato,
    'userID'              : userID,
    'documentID'          : documentID,
    'presidente'          : presidente,
    'tesorero'            : tesorero,
    'direccion1'          : direccion1,
    'coloniaPoblacion'    : coloniaPoblacion,
    'delegacionMunicipio' : delegacionMunicipio,
    'ciudad'              : ciudad,
    'estado'              : estado,
    'cp'                  : cp,
    'pais'                : pais,
    'fechaCaptura'        : fechaCaptura,
    'contratoId'          : contratoId,
  };

  Solicitud.fromjson(Map<String, dynamic> json){
    this.idSolicitud         = json['idSolicitud'];
    this.idGrupo             = json['idGrupo'];
    this.nombreGrupo         = json['nombreGrupo'];
    this.capital             = json['capital'];
    this.nombre              = json['nombre'];
    this.segundoNombre       = json['segundoNombre'];
    this.primerApellido      = json['primerApellido'];
    this.segundoApellido     = json['segundoApellido'];
    this.fechaNacimiento     = json['fechaNacimiento'];
    this.curp                = json['curp'];
    this.rfc                 = json['rfc'];
    this.telefono            = json['telefono'];
    this.status              = json['status'];
    this.tipoContrato        = json['tipoContrato'];
    this.userID              = json['userID'];
    this.documentID          = json['documentID'];
    this.presidente          = json['presidente'];
    this.tesorero            = json['tesorero'];
    this.direccion1          = json['direccion1'];
    this.coloniaPoblacion    = json['coloniaPoblacion'];
    this.delegacionMunicipio = json['delegacionMunicipio'];
    this.ciudad              = json['ciudad'];
    this.estado              = json['estado'];
    this.cp                  = json['cp'];
    this.pais                = json['pais'];
    this.fechaCaptura        = json['fechaCaptura'];
    this.contratoId          = json['contratoId'];
  }
}