//Firebase
class AuthObject{
  String uid;
  String email;
  bool result;
  String mensaje;

  AuthObject({
    this.email,
    this.mensaje,
    this.result,
    this.uid
  });

  @override
  String toString() {
    return '{email: $email, mensaje: $mensaje, result: $result, uid: $uid';
  }
}

//APi ValeConfia
class AuthVCAPI{
  int resultCode;
  String resultDesc;
  String token;
  int usuarioId;
  int sistemaId;
  String nombreCom;
  String ultimoInicioSesion;

  AuthVCAPI({
    this.nombreCom,
    this.resultCode,
    this.resultDesc,
    this.sistemaId,
    this.token,
    this.ultimoInicioSesion,
    this.usuarioId
  });

  @override
  String toString() {
    return '{nombre: $nombreCom, mensaje: $resultDesc, result: $resultCode, uid: $usuarioId}';
  }
}