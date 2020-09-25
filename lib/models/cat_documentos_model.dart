class CatDocumento{
  int tipo;
  String descDocumento;

  CatDocumento({
    this.tipo,
    this.descDocumento
  });

  Map<String, dynamic> toJson() =>{
    'tipo' : tipo,
    'descDocumento' : descDocumento
  };

  CatDocumento.fromjson(Map<String, dynamic> json){
    this.tipo = json['tipo'];
    this.descDocumento = json['descDocumento'];
  }
}