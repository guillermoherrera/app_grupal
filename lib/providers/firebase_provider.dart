import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/classes/shared_preferences.dart';

class FirebaseProvider{
  final _sharedActions = SharedActions();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot _querySnapshot;
  Query _query;

  Future<void> getUserInfo() async{
    try{
      //info de usuario
      String userID = await _sharedActions.getUserId();
      _query = _firestore.collection("UsuariosTipos").where('uid', isEqualTo: userID);
      _querySnapshot = await _query.get();
      if(_querySnapshot.docs.length > 0 ){
        await _sharedActions.saveUserInfo(_querySnapshot.docs[0]);
      }else{
        throw Exception('Usuario no configurado');
      }
    }catch(e){
      print('### Error FirebaseProvider getUserInfo ### $e');
      await _sharedActions.removeUserInfo();
    }
  }
  
  Future<void> getCatalogos() async{
    try{

      //catDocumentos
      List<CatDocumento> catDocumentos = List();
      await DBProvider.db.deleteCatDocumentos();
      _query = _firestore.collection("catDocumentos").where('activo', isEqualTo: true);
      _querySnapshot = await _query.get();
      for (DocumentSnapshot value in _querySnapshot.docs) {
        final catDocumento = CatDocumento(tipo: value.data()['tipo'], descDocumento: value.data()['descDocumento'] );
        catDocumentos.add(catDocumento);
      }
      DBProvider.db.insertaCatDocumentos(catDocumentos);

      //catEstados
      List<CatEstado> catEstados = List();
      await DBProvider.db.deleteCatEstados();
      _query = _firestore.collection("catEstados");
      _querySnapshot = await _query.get();
      for (DocumentSnapshot value in _querySnapshot.docs) {
        final catEstado = CatEstado(codigo: value.data()['codigo'], estado: value.data()['estado'] );
        catEstados.add(catEstado);
      }
      DBProvider.db.insertaCatEstados(catEstados);

      //catIntegramtes
      await DBProvider.db.deleteCatIntegrantes();
      _query = _firestore.collection("catIntegrantesGrupo");
      _querySnapshot = await _query.get();
      DBProvider.db.insertaCatIntegrantes(_querySnapshot.docs[0].data()['cantidad']);

    }catch(e){
      print('### Error FirebaseProvider getCatalogos ### $e');
    }
  }
}