import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/authentication_model.dart';
import 'package:app_grupal/models/integrantes_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/models/contrato_model.dart';

class AsesoresProvider {
  final SharedActions _sharedActions = new SharedActions();

  Future<AuthVCAPI> loginVCAPI(String usuario, String password)async{
    final url = Uri.http(Constants.baseURL, '/v1.0/loginGrupal');
    Map<String, String> body = {
      'distribuidor': usuario,
      'password' : password,
      'identificador': 'IDXXXX',
    };

    Map<String, String> headers= {};

    AuthVCAPI result = new AuthVCAPI(resultCode: 1);

    try {
      print('url: $url');
      print('headers: $body');
      final resp = await http.post(url, headers: headers, body: body).timeout(Duration(seconds: 10));
      final decodeData = json.decode(resp.body);
      if(decodeData['resultCode'] == 1)  throw(decodeData['resultDesc']);
      result = new AuthVCAPI(
        resultCode        : decodeData['resultCode'],
        resultDesc        : decodeData['resultDesc'],
        nombreCom         : decodeData['nombreCom'],
        sistemaId         : decodeData['sistemaId'],
        token             : decodeData['token'],
        ultimoInicioSesion: decodeData['ultimoInicioSesion'],
        usuarioId         : decodeData['usuarioId'],
      );
    } catch (e) {
      result.resultDesc = e.toString();
      print(e);
    }

    return result;
  }

  //ASESORES PROVIDER ASESORESAPI

  Future<List<dynamic>> procesaRespuestaLista(url, headers, clase) async{
    List<dynamic> listaRespuesta;
    try{
      print('url: $url');
      print('headers: $headers');
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

  Future<List<Contrato>> consultaCartera()async{
    final url = Uri.https(Constants.baseURL, '/cartera/${Constants.consultaContratos}');
    Map<String, String> headers= {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId()};
    
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

  Future<ContratoDetalle> consultaContratoDetalle(int contrato) async{
    final url = Uri.https(Constants.baseURL, '/cartera/${Constants.consultaIntegrantes}');
    Map<String, String> headers = {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId(),
      'contrato': '$contrato'};

    ContratoDetalle contratoDetalle = new ContratoDetalle();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, contratoDetalle);

    return listaProcesada.isEmpty ? ContratoDetalle() : listaProcesada[0];
  }

  Future<List<Integrante>> consultaIntegrantesCartera(int contrato, String cveCliente) async{
    final url = Uri.https(Constants.baseURL, '/cartera/${Constants.creditoDetalle}');
    Map<String, String> headers = {
      'x-api-key'  : Constants.apiKey,
      'userID'     : await _sharedActions.getUserId(),
      'contrato'   : '$contrato',
      'cveCliente' : cveCliente};

    Integrantes integrantes = new Integrantes();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, integrantes);
    
    return listaProcesada.isEmpty ? [] : listaProcesada.cast<Integrante>();
  }

}