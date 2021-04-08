import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/authentication_model.dart';
import 'package:app_grupal/models/cat_documentos_model.dart';
import 'package:app_grupal/models/contrato_model.dart';
import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/models/integrantes_model.dart';
import 'package:app_grupal/models/params_app_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VCAPIProvider {
  final SharedActions _sharedActions = new SharedActions();
  final CustomSnakBar _customSnakBar = new CustomSnakBar();

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
      result = AuthVCAPI.jsonMap(decodeData);
    } catch (e) {
      result.resultDesc = e.toString();
      print(e);
    }

    return result;
  }

  //GET
  Future <dynamic> procesaRespuesta(url, headers, clase, {snackBar}) async{
    dynamic respuesta;
    try{
      print('url: $url');
      print('headers: $headers');
      final resp = await http.get(url, headers: headers).timeout(Duration(seconds: 15));
      if(resp.statusCode != 200) throw(resp.reasonPhrase);
      final decodeData = json.decode(resp.body);
      respuesta = clase.fromJson(decodeData['data']);
    }catch(e){
      print(e);
      if(snackBar != null)
        _customSnakBar.showSnackBar(Constants.errorAuth('$e'), Duration(milliseconds: 3000), Colors.pink, Icons.error_outline, snackBar);
      respuesta = {};
    }
    return respuesta;
  }

  Future<List<dynamic>> procesaRespuestaLista(url, headers, clase, {snackBar}) async{
    List<dynamic> listaRespuesta;
    try{
      print('url: $url');
      print('headers: $headers');
      final resp = await http.get(url, headers: headers).timeout(Duration(seconds: 15));
      if(resp.statusCode != 200) throw(resp.reasonPhrase);
      final decodeData = json.decode(resp.body);
      listaRespuesta = clase.fromJsonList(decodeData['data']);
    }catch(e){
      print(e);
      if(snackBar != null)
        _customSnakBar.showSnackBar(Constants.errorAuth('$e'), Duration(milliseconds: 3000), Colors.pink, Icons.error_outline, snackBar);
      listaRespuesta = List();
    }
    return listaRespuesta;
  }

  Future<List<ContratoVCAPI>> consultaGrupos({snackBar})async{
    Map<String, dynamic> info = await _sharedActions.getUserInfo();
    final url = Uri.http(Constants.baseURL, '/v1.0/secure/grupal/Consulta/grupos/${info['user']}');
    Map<String, String> headers= {
      'Authorization'  : 'Bearer ${info['token']}',
    };
    
    ContratosVCAPI contratos = new ContratosVCAPI();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, contratos, snackBar: snackBar);
    
    return listaProcesada.cast<ContratoVCAPI>();
  }

  Future<List<IntegranteVCAPI>> consultaIntegrantes(int contratoId, {snackBar})async{
    Map<String, dynamic> info = await _sharedActions.getUserInfo();
    final url = Uri.http(Constants.baseURL, '/v1.0/secure/grupal/Consulta/Integrantes/${info['user']}/$contratoId');
    Map<String, String> headers= {
      'Authorization'  : 'Bearer ${info['token']}',
    };
    
    IntegrantesVCAPI contratos = new IntegrantesVCAPI();
    List<dynamic> listaProcesada = await procesaRespuestaLista(url, headers, contratos, snackBar: snackBar);
    
    return listaProcesada.cast<IntegranteVCAPI>();
  }

  Future<ParamsApp> consultaParamsApp()async{
    Map<String, dynamic> info = await _sharedActions.getUserInfo();
    final url = Uri.http(Constants.baseURL, '/v1.0/secure/grupal/Params/${info['user']}');
    Map<String, String> headers= {
      'Authorization'  : 'Bearer ${info['token']}',
    };
    
    ParamsApp params = new ParamsApp();
    dynamic  respuestaProcesada = await procesaRespuesta(url, headers, params);
    
    //save Parametros y Catalogos
    try{

      //Documentos
      List<CatDocumento> catDocumentos = List();
      await DBProvider.db.deleteCatDocumentos();
      for (CatDocumento value in respuestaProcesada.documentos) {
        catDocumentos.add(value);
      }
      DBProvider.db.insertaCatDocumentos(catDocumentos);
      
      //Integrantes
      DBProvider.db.insertaCatIntegrantes(respuestaProcesada.cantidadIntegrantesMin);

      //AccesoConfiashop
      _sharedActions.setAccesoConfiashop(respuestaProcesada.accesoConfiashop);
      print('### Parametros y Catalogos actualizados');
    }catch(e){
      print('### Error al guardar Parametros y Catalogos ->>> $e');
    }
    return respuestaProcesada;
  }

}