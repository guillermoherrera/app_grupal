class CatEstado{
  String estado;
  String codigo;

  CatEstado({
    this.estado,
    this.codigo
  });

  CatEstado.fromJson(Map<String, dynamic> json){
    this.estado = 'estado';
    this.codigo = 'codigo';
  }
}