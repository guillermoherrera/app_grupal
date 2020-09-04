import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/integrantes_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/models/contrato_model.dart';

class AsesoresProvider {
  final SharedActions _sharedActions = new SharedActions();

  Future<List<dynamic>> procesaRespuestaLista(url, headers, clase) async{
    List<dynamic> listaRespuesta;
    try{
      final resp = await http.get(url, headers: headers).timeout(Duration(seconds: 10));
      final decodeData = json.decode(resp.body);
      listaRespuesta = clase.fromJsonList(decodeData['data']);
    }catch(e){
      print(e);
      listaRespuesta = List();
    }
    return listaRespuesta;
  }
  
  Future<List<Contrato>> consultaRenovaciones(String fechaInicio, String fechaFin) async{
    final url = Uri.https(Constants.baseURL, '/renovacion/${Constants.consultaContratos}');
    Map<String, String> headers= {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId(),
      'fechaInicio': fechaInicio,
      'fechaFin'   : fechaFin};
    
    Contratos contratos = new Contratos();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, contratos);
    
    return listaProcesada.cast<Contrato>();
  }

  Future<List<Integrante>> consultaIntegrantesRenovacion(int contrato) async{
    final url = Uri.https(Constants.baseURL, '/cartera/${Constants.consultaIntegrantes}');
    Map<String, String> headers = {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId(),
      'contrato': '$contrato'};

    Integrantes integrantes = new Integrantes();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, integrantes);
    
    return listaProcesada.cast<Integrante>();
  }

}