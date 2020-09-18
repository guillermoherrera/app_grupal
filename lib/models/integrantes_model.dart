class Integrantes{
  List<Integrante> items = List();

  Integrantes();

  List<Integrante> fromJsonList(dynamic jsonList){
    //print(jsonList['integrantes']);
    if(jsonList == null) return List();
    for(var item in jsonList['integrantes']){
      final integrante = Integrante.jsonMap(item);
      integrante.renovado = jsonList['renovado'];
      items.add(integrante);
    }

    return items;
  }
}

class Integrante{
  String cveCli;
  String nombreCom;
  String telefonoCel;
  double importeT;
  int diaAtr;
  double capital;
  int noCda;
  bool tesorero;
  bool presidente;
  bool renovado;

  Integrante({
    this.cveCli,
    this.nombreCom,
    this.telefonoCel,
    this.importeT,
    this.diaAtr,
    this.capital,
    this.noCda,
    this.tesorero,
    this.presidente,
    this.renovado
  });

  Integrante.jsonMap(Map<String, dynamic> json){
    cveCli = json['cveCli'];
    nombreCom = json['nombreCom'];
    telefonoCel = json['telefonoCel'];
    importeT = json['importeT'] / 1;
    diaAtr = json['diaAtr'];
    capital = json['capital'] / 1;
    noCda = json['noCda'];
    tesorero = json['tesorero'];
    presidente = json['presidente'];
  }
}