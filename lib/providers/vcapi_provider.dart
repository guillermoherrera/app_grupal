import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/authentication_model.dart';
//import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VCAPIProvider {
  //final SharedActions _sharedActions = new SharedActions();

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
}