class CatEstado{
  String estado;
  String codigo;

  CatEstado({
    this.estado,
    this.codigo
  });

  Map<String, dynamic> toJson() =>{
    'estado' : estado,
    'codigo' : codigo
  };

  CatEstado.fromjson(Map<String, dynamic> json){
    this.estado = json['estado'];
    this.codigo = json['codigo'];
  }
}