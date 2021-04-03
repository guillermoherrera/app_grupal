import 'package:app_grupal/models/authentication_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedActions{
  SharedPreferences preferences;

  init() async{
    preferences = await SharedPreferences.getInstance(); 
  }

  setUserAuth(user, pass, uid) async{
    await init();
    preferences.setString('user', user);
    preferences.setString('pass', pass);
    preferences.setString('uid', uid.toString());

  }

  setPassInfo(String pass) async{
    preferences.setString('pass', pass);
    preferences.setBool("passGenerico", false);
  }

  setUserInfo(AuthVCAPI authVCAPI) async{
    preferences.setString('nombreCom', authVCAPI.nombreCom);
    preferences.setInt('sistemaId', authVCAPI.sistemaId);
    preferences.setString('token', authVCAPI.token);
  }

  Future<Map<String, dynamic>> getUserInfo() async{
    await init();
    return {
      'nombreCom' : preferences.getString('nombreCom'),
      'sistemaId' : preferences.getInt('sistemaId'),
      'token'     : preferences.getString('token'),
      'uid'       : preferences.getInt('usuarioId'),
      //'user'    : preferences.getString('user'),
      //'name'    : preferences.getString('name'),
      //'uid'     : preferences.getString('uid'),
      //'sistema' : preferences.getInt('sistema'),
      //'sistemaDesc' : preferences.getString('sistemaDesc'),
      //'pass'    : preferences.getString('pass'),
      //'tipoUsuario' : preferences.getInt('tipoUsuario'),
      //'documentID'    : preferences.getString('documentID'),
      //'passGenerico'    : preferences.getBool('passGenerico'),
    };
  }

  Future<String> getUserId() async{
    await init();
    return preferences.getString('uid');
  }

  Future<void> saveUserInfo(DocumentSnapshot documentSnapshot) async{
    await init();
    preferences.setInt("tipoUsuario", documentSnapshot.data()['tipoUsuario']);
    preferences.setString("name", documentSnapshot.data()['nombre']);
    preferences.setBool("passGenerico", documentSnapshot.data()['passGenerico']);
    preferences.setString("documentID", documentSnapshot.id);
    preferences.setInt("sistema", documentSnapshot.data()['sistema']);
    preferences.setString("sistemaDesc", documentSnapshot.data()['sistemaDesc']);
    preferences.setBool('Sincronizando?', false);
  }

  Future<void> removeUserInfo()async{
    await init();
    preferences.remove('tipoUsuario');
    preferences.remove('name');
    preferences.remove('passGenerico');
    preferences.remove('documentID');
    preferences.remove('sistema');
    preferences.remove('sistemaDesc');
  }

  Future<void> saveSolicitud(Solicitud solicitud, int currentPage) async{
    await init();
    if(currentPage == 0){ 
      preferences.setString('importe', '${solicitud.capital}');
      preferences.setString('nombrePrimero', solicitud.nombre);
      preferences.setString('nombreSegundo', solicitud.segundoNombre);
      preferences.setString('apellidoPrimero', solicitud.primerApellido);
      preferences.setString('apellidoSegundo', solicitud.segundoApellido);
      preferences.setInt('fechaNacimiento', solicitud.fechaNacimiento);
      preferences.setString('curp', solicitud.curp);
      preferences.setString('rfc', solicitud.rfc);
      preferences.setString('telefono', solicitud.telefono);
    }else if(currentPage == 1){
      preferences.setString('direccion1', solicitud.direccion1);
      preferences.setString('coloniaPoblacion', solicitud.coloniaPoblacion);
      preferences.setString('delegacionMunicipio', solicitud.delegacionMunicipio);
      preferences.setString('ciudad', solicitud.ciudad);
      preferences.setString('estado', solicitud.estado);
      preferences.setString('cp', '${solicitud.cp}');
      preferences.setString('pais', solicitud.pais);
    }
  }

  Future<Solicitud> getSolicitud() async{
    await init();
    Solicitud solicitud = new Solicitud();
    try{
      solicitud.capital             = double.parse(preferences.getString('importe'));
      solicitud.nombre              = preferences.getString('nombrePrimero');
      solicitud.segundoNombre       = preferences.getString('nombreSegundo');
      solicitud.primerApellido      = preferences.getString('apellidoPrimero');
      solicitud.segundoApellido     = preferences.getString('apellidoSegundo');
      solicitud.fechaNacimiento     = preferences.getInt('fechaNacimiento');
      solicitud.curp                = preferences.getString('curp');
      solicitud.rfc                 = preferences.getString('rfc');
      solicitud.telefono            = preferences.getString('telefono');
      solicitud.direccion1          = preferences.getString('direccion1');
      solicitud.coloniaPoblacion    = preferences.getString('coloniaPoblacion');
      solicitud.delegacionMunicipio = preferences.getString('delegacionMunicipio');
      solicitud.ciudad              = preferences.getString('ciudad');
      solicitud.estado              = preferences.getString('estado');
      solicitud.cp                  = preferences.getString('cp') != null ? int.parse(preferences.getString('cp')) : null;
      solicitud.pais                = preferences.getString('pais');
    }
    catch(e){
      solicitud.capital = 0.0;
      print('### Error SharedActions getSolicitud ###');
    }
    return solicitud;
  }

  Future<void> removeSolicitud()async{
    await init();
    preferences.remove('importe');
    preferences.remove('nombrePrimero');
    preferences.remove('nombreSegundo');
    preferences.remove('apellidoPrimero');
    preferences.remove('apellidoSegundo');
    preferences.remove('fechaNacimiento');
    preferences.remove('curp');
    preferences.remove('rfc');
    preferences.remove('telefono');
    preferences.remove('direccion1');
    preferences.remove('coloniaPoblacion');
    preferences.remove('delegacionMunicipio');
    preferences.remove('ciudad');
    preferences.remove('estado');
    preferences.remove('cp');
    preferences.remove('pais');
  }

  Future<void> setSincRegistroInit()async{
    await init();
    preferences.setBool('Sincronizando?', true);
    preferences.setString('horaSincronizacion', formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, " ", HH, ':', nn, ':', ss]));
  }

  Future<void> setSincTermina()async{
    await init();
    preferences.setBool('Sincronizando?', false);
  }

  Future<Map<String, dynamic>> getSincRegistroInfo() async{
    await init();
    return {
      'Sincronizando?'        : preferences.getBool('Sincronizando?'),
      'horaSincronizacion'    : preferences.getString('horaSincronizacion'),
    };
  }

  clear() async{
    await init();
    preferences.clear();
  }

}