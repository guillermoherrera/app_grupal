class Integrantes{
  List<Integrante> items = List();

  Integrantes();

  List<Integrante> fromJsonList(dynamic jsonList){
    //print(jsonList['integrantes']);
    if(jsonList == null) return List();
    if(jsonList.containsKey("folio")) return fromJsonListCartera(jsonList);
    for(var item in jsonList['integrantes']){
      final integrante = Integrante.jsonMap(item);
      integrante.renovado = jsonList['renovado'];
      items.add(integrante);
    }

    return items;
  }

  List<Integrante> fromJsonListCartera(dynamic jsonData){
    if(jsonData == null) return List();
    final integrante = Integrante.jsonMapCartera(jsonData);
    items.add(integrante);
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
  //cartera detalle
  String fechaTermina;
  String fechaUltimoPago;
  double saldoActual;
  double salAtr;
  int pagos;
  int folio;
  double interes;

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
    this.renovado,

    this.fechaTermina,
    this.fechaUltimoPago,
    this.saldoActual,
    this.salAtr,
    this.pagos,
    this.folio,
    this.interes
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

  Integrante.jsonMapCartera(Map<String, dynamic> json){
    cveCli          = json['cveCli'];
    importeT        = json['importeT'] / 1;
    diaAtr          = json['diaAtr'];
    capital         = json['capital'] / 1;
    noCda           = json['noCda'];
    fechaTermina    = json['fechaTermina'];
    fechaUltimoPago = json['fechaUltimoPago'];
    saldoActual     = json['saldoActual'] / 1;
    salAtr          = json['salAtr'] / 1;
    pagos           = json['pagos'];
    folio           = json['folio'];
    interes         = json['interes'] / 1;
  }
}

class IntegrantesVCAPI{
  List<IntegranteVCAPI> items = List();

  IntegrantesVCAPI();

  List<IntegranteVCAPI> fromJsonList(dynamic jsonList){
    if(jsonList == null) return List();
    for(var item in jsonList){
      final integrante = IntegranteVCAPI.jsonMap(item);
      items.add(integrante);
    }

    return items;
  }
}

class IntegranteVCAPI{
  String cveCli;
  String nombreCom;
  String curp;
  String fechaNacimiento;
  String direccion;
  String telefonoCel;
  double importeT;
  int diaAtr;
  double capital;
  int noCda;
  bool tesorero;
  bool presidente;
  int grupo; 
  bool pedidoActivo;

  String ticket;
  bool pedido;
  String detallePedido;

  IntegranteVCAPI({
    this.cveCli,
    this.nombreCom,
    this.telefonoCel,
    this.importeT,
    this.diaAtr,
    this.capital,
    this.noCda,
    this.tesorero,
    this.presidente,
    this.curp,
    this.direccion,
    this.fechaNacimiento,
    this.grupo,
    this.pedidoActivo,

    this.ticket,
    this.pedido,
    this.detallePedido
  });

  IntegranteVCAPI.jsonMap(Map<String, dynamic> json){
    cveCli          = json['cveCli'];
    nombreCom       = json['nombreCom'];
    telefonoCel     = json['telefonoCel'];
    importeT        = json['importeT'] / 1;
    diaAtr          = json['diaAtr'];
    capital         = json['capital'] / 1;
    noCda           = json['noCda'];
    tesorero        = json['tesorero'];
    presidente      = json['presidente'];
    curp            = json['curp'];
    direccion       = json['direccion'];
    fechaNacimiento = json['fechaNacimiento'];
    grupo           = json['grupo']; 
    pedidoActivo    = json['pedidoActivo']; 
  }
}