class Contratos{
  List<Contrato> items = List();
  
  Contratos();
  
  List<Contrato> fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return List();

    for(var item in jsonList){
      final contrato = new Contrato.jsonMap(item);
      items.add(contrato);
    }
    return items;
  }
}

class Contrato{
  int contratoId;
  String nombreGeneral;
  String fechaTermina;
  
  String fechaInicio;
  double importe;
  double saldoActual;
  double saldoAtrazado;
  int diasAtrazo;
  double pagoXPlazo;
  int ultimoPagoPlazo;
  int plazos;
  double capital;
  double interes;
  String contacto;
  String status;
  int integrantesCant;
  bool renovado;

  Contrato({
    this.contratoId,
    this.fechaTermina,
    this.nombreGeneral,

    this.capital,
    this.contacto,
    this.diasAtrazo,
    this.fechaInicio,
    this.importe,
    this.integrantesCant,
    this.interes,
    this.pagoXPlazo,
    this.plazos,
    this.saldoActual,
    this.saldoAtrazado,
    this.status,
    this.ultimoPagoPlazo,
    this.renovado
  });

  Contrato.jsonMap(Map<String, dynamic> json){
    contratoId = json['contratoId']; 
    fechaTermina = json['fechaTermina']; 
    nombreGeneral = json['nombreGeneral']; 

    capital = json['capital']; 
    contacto = json['contacto']; 
    diasAtrazo = json['diasAtrazo']; 
    fechaInicio = json['fechaInicio']; 
    importe = json['importe']; 
    integrantesCant = json['integrantesCant']; 
    interes = json['interes']; 
    pagoXPlazo = json['pagoXPlazo']; 
    plazos = json['plazos']; 
    saldoActual = json['saldoActual']; 
    saldoAtrazado = json['saldoAtrazado']; 
    status = json['status']; 
    ultimoPagoPlazo = json['ultimoPagoPlazo']; 
    renovado = json['renovado'];
  }
}