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

  List<CatDocumento> fromJsonList(dynamic jsonList){
    List<CatDocumento> items = List();
    if(jsonList == null) return List();
    for(var item in jsonList){
      final documento = CatDocumento.fromjson(item);
      items.add(documento);
    }
    return items;
  }
}