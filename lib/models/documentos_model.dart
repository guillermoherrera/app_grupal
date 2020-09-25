class Documento{
  int idDocumentoSolicitudes;
  int idSolicitud;
  int tipoDocumento;
  String documento;
  int version;
  int cambioDoc;
  String observacionCambio;

  Documento({
    this.cambioDoc,
    this.documento,
    this.idDocumentoSolicitudes,
    this.idSolicitud,
    this.observacionCambio,
    this.tipoDocumento,
    this.version,
  });
}