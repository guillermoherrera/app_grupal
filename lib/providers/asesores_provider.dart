import 'package:app_grupal/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/models/contrato_model.dart';

class AsesoresProvider {
  final SharedActions _sharedActions = new SharedActions();

  Future<List<Contrato>> procesaRespuestaContratos(url, headers) async{
    List<Contrato> contratos;
    try{
      final resp = await http.get(url, headers: headers).timeout(Duration(seconds: 10));
      final decodeData = json.decode(resp.body);
      contratos = Contratos.fromJsonList(decodeData['data']).items;
    }catch(e){
      contratos = List();
    }
    return contratos;
  }
  
  Future<List<Contrato>> consultaRenovaciones(String fechaInicio, String fechaFin) async{
    final url = Uri.https(Constants.baseURL, '/renovacion/${Constants.consultaContratos}');
    Map<String, String> headers= {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId(),
      'fechaInicio': fechaInicio,
      'fechaFin'   : fechaFin};
    
    return procesaRespuestaContratos(url, headers);
  }

}