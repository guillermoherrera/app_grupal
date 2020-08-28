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