import 'dart:io';

import 'package:app_grupal/helpers/utilerias.dart';
import 'package:app_grupal/models/firebase_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';

class FirebaseProvider{
  final _sharedActions = SharedActions();
  final _utilerias = Utilerias();
  final _firebaseGrupo = FirebaseGrupo();
  final _firebaseRenovacion  = FirebaseRenovacion();
  final _firebasePersona = FirebasePersona();
  final _firebaseDireccion = FirebaseDireccion();
  FirebaseSolicitud _firebaseSolicitud = FirebaseSolicitud();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot _querySnapshot;
  Query _query;
  final _timeOutDutaion = Duration(milliseconds: 10000);

  Future<void> getUserInfo() async{
    try{
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

  sendRenovacionesToFirebase() async{
    if(!(await _utilerias.checkInternet()))
      return null;
    //validar Sincronizando
    Map<String, dynamic> userInfo = await _sharedActions.getUserInfo();
    _sharedActions.setSincRegistroInit();

    List<Grupo> gruposPendientes = await DBProvider.db.getGruposPendientes(userInfo['uid']);
    gruposPendientes.forEach((e)async{
      _sendRenovacionGrupo(e, userInfo['sistema']).then((grupoID)async{
        
        await DBProvider.db.getRenovacionesPendientesByGrupo(e.idGrupo).then((listaSolicitudes)async{
          await _sendRenovacionIntegrantesGrupo(listaSolicitudes, grupoID, e.contratoId, userInfo['sistema']);
        }).catchError((e)=>print('### Error getRenovacionesByGrupo ###'));

      }).catchError((e)=>print('### Error _sendRenovacionGrupo ###'));
      
    });
  }

  Future<String> _sendRenovacionGrupo(Grupo renovacionGrupo, int sistema)async{
    final firebaseGrupo = _firebaseGrupo.getFirebaseGrupo(renovacionGrupo);
    if(firebaseGrupo.grupoID == null){
      Map objFirebaseGrupo = firebaseGrupo.toJson();
      objFirebaseGrupo.putIfAbsent('sistema', ()=> sistema);
      var result = await _firestore.collection("GruposRenovacion").add(objFirebaseGrupo);
      await DBProvider.db.updateGrupoGrupoID(renovacionGrupo.idGrupo, result.id);
      return result.id;
    }else{
      return firebaseGrupo.grupoID;
    }
  }

  _sendRenovacionIntegrantesGrupo(List<Renovacion> solicitudesRenovacion, String grupoID, int contratoId, int sistema)async{
    int solicitudesSubidas = 0;
    for(Renovacion e in solicitudesRenovacion){
    //solicitudesRenovacion.forEach((e)async{
      var firebaseRenovacion;
      Map objFirebaseRenovacion;
      if((e.cveCli != null && e.cveCli != '') && e.status == 0){
        firebaseRenovacion = _firebaseRenovacion.getFirebaseRenovacion(e, grupoID, contratoId);
      }else{
        Solicitud solicitud = await DBProvider.db.getSolicitudById(e.idSolicitud);
        firebaseRenovacion = await _buildFirebaseSolicitud(solicitud, grupoID);
      }
      if(firebaseRenovacion != null){
        firebaseRenovacion.contratoId = contratoId;
        objFirebaseRenovacion = firebaseRenovacion.toJson();
        print(firebaseRenovacion);
        //if(firebaseRenovacion.contratoId == null) objFirebaseRenovacion.putIfAbsent('contratoId', ()=> contratoId);
        objFirebaseRenovacion.putIfAbsent('sistema', ()=> sistema);
        var result = await _firestore.collection("Renovaciones").add(objFirebaseRenovacion);
        print(result);
        solicitudesSubidas += 1;
        await DBProvider.db.updateRenovacionStatus(e.idRenovacion, 1);
      }
    }
    if(solicitudesSubidas == solicitudesRenovacion.length) await DBProvider.db.updateGrupoStatus(solicitudesRenovacion[0].idGrupo, 2);
  }

  Future<FirebaseSolicitud> _buildFirebaseSolicitud(Solicitud solicitud, String grupoID)async{
    List<Documento> documentosSolicitud = await _getDocumentos(solicitud);
    if(documentosSolicitud.length > 0){
      final persona = _firebasePersona.getFirebasePersona(solicitud);
      final direccion = _firebaseDireccion.getFirebaseDireccion(solicitud);
      _firebaseSolicitud = _firebaseSolicitud.getFirebaseSolicitud(solicitud, persona.toJson(), direccion.toJson(), documentosSolicitud, grupoID);
    }else{
      _firebaseSolicitud = null;
    }

    return _firebaseSolicitud;
  }

  Future<List<Documento>> _getDocumentos(Solicitud solicitud)async{
    List<Documento> documentos = await DBProvider.db.getDocumentosbySolicitud(solicitud.idSolicitud);
    try{
      //documentos.forEach((e)async{
      for(Documento e in documentos){
        String mimeType = mime(e.documento);
        String ext = "."+mimeType.split("/")[1];
        StorageReference reference = _firebaseStorage.ref().child('Documentos').child('${solicitud.curp}').child('${DateTime.now().millisecondsSinceEpoch}_${e.tipoDocumento}'+ext);
        StorageUploadTask uploadTask = reference.putFile(File(e.documento));
        StorageTaskSnapshot downloadURL = await uploadTask.onComplete.timeout(_timeOutDutaion);
        e.documento = await downloadURL.ref.getDownloadURL();
      }
    }catch(e){
      documentos = [];
    }
    return documentos;
  }
}