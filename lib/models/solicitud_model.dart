class Solicitud{

  int idSolicitud;
  int idGrupo;
  String nombreGrupo;
  double importe;
  String nombrePrimero;
  String nombreSegundo;
  String apellidoPrimero;
  String apellidoSegundo;
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

  Solicitud({
    this.idSolicitud,
    this.idGrupo,
    this.nombreGrupo,
    this.importe,
    this.nombrePrimero,
    this.nombreSegundo,
    this.apellidoPrimero,
    this.apellidoSegundo,
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
  });
}