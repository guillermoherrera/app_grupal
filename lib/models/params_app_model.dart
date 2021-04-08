import 'package:app_grupal/models/cat_documentos_model.dart';

class ParamsApp{
  bool accesoConfiashop;
  int cantidadIntegrantesMin;
  List<CatDocumento> documentos;

  ParamsApp({
    this.accesoConfiashop,
    this.cantidadIntegrantesMin,
    this.documentos,
  });

  ParamsApp fromJson(Map<String, dynamic> json){
    final params = new ParamsApp();
    CatDocumento catDocumento = new CatDocumento();

    params.accesoConfiashop = json['accesoConfiashop'];
    params.cantidadIntegrantesMin = json['cantidadIntegrantesMin'];
    params.documentos =  catDocumento.fromJsonList(json['documentos']);

    return params;
  }
}