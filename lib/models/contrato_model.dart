import 'package:app_grupal/models/integrantes_model.dart';

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
  int ultimoPlazoPag;
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
    this.ultimoPlazoPag,
    this.renovado
  });

  Contrato.jsonMap(Map<String, dynamic> json){
    contratoId = json['contratoId']; 
    fechaTermina = json['fechaTermina']; 
    nombreGeneral = json['nombreGeneral']; 

    capital = json['capital'] == null ? json['capital'] : json['capital'] / 1 ; 
    contacto = json['contacto']; 
    diasAtrazo = json['diasAtrazo']; 
    fechaInicio = json['fechaInicio']; 
    importe = json['importe'] == null ? json['importe'] : json['importe'] / 1; 
    integrantesCant = json['integrantesCant']; 
    interes = json['interes'] == null ? json['interes'] : json['interes'] / 1; 
    pagoXPlazo = json['pagoXPlazo'] == null ? json['pagoXPlazo'] : json['pagoXPlazo'] / 1; 
    plazos = json['plazos']; 
    saldoActual = json['saldoActual'] == null ? json['saldoActual'] : json['saldoActual'] / 1; 
    saldoAtrazado = json['saldoAtrazado'] == null ? json['saldoAtrazado'] : json['saldoAtrazado'] / 1; 
    status = json['status']; 
    ultimoPlazoPag = json['ultimoPlazoPag']; 
    renovado = json['renovado'];
  }
}

class ContratoDetalle{
  bool result;
  String mensaje;
  Contrato contrato;
  List<Integrante> integrantes;

  ContratoDetalle({
    this.contrato,
    this.integrantes
  });

  List<ContratoDetalle> items = List();
  //ContratoDetalle();

  List<ContratoDetalle> fromJsonList(dynamic jsonList){
    Contrato contrato = Contrato.jsonMap(jsonList);

    List<Integrante> integrantes = List();
    if(jsonList == null) return List();
    for(var item in jsonList['integrantes']){
      final integrante = Integrante.jsonMap(item);
      integrante.renovado = jsonList['renovado'];
      integrantes.add(integrante);
    }

    items.add(ContratoDetalle(contrato: contrato,integrantes:  integrantes));
    print(items);
    return items;
  }
}