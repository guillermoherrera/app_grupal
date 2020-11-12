import 'dart:io';

import 'package:app_grupal/helpers/utilerias.dart';
import 'package:app_grupal/models/firebase_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
  final _timeOutDuration = Duration(milliseconds: 10000);

  Future<void> getUserInfo() async{
    try{
      String userID = await _sharedActions.getUserId();
      _query = _firestore.collection("UsuariosTipos").where('uid', isEqualTo: userID);
      _querySnapshot = await _query.get().timeout(_timeOutDuration);
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
  
  Future<bool> getCatalogos() async{
    try{

      //catDocumentos
      List<CatDocumento> catDocumentos = List();
      await DBProvider.db.deleteCatDocumentos();
      _query = _firestore.collection("catDocumentos").where('activo', isEqualTo: true);
      _querySnapshot = await _query.get().timeout(_timeOutDuration);
      for (DocumentSnapshot value in _querySnapshot.docs) {
        final catDocumento = CatDocumento(tipo: value.data()['tipo'], descDocumento: value.data()['descDocumento'] );
        catDocumentos.add(catDocumento);
      }
      DBProvider.db.insertaCatDocumentos(catDocumentos);

      //catEstados
      List<CatEstado> catEstados = List();
      await DBProvider.db.deleteCatEstados();
      _query = _firestore.collection("catEstados");
      _querySnapshot = await _query.get().timeout(_timeOutDuration);
      for (DocumentSnapshot value in _querySnapshot.docs) {
        final catEstado = CatEstado(codigo: value.data()['codigo'], estado: value.data()['estado'] );
        catEstados.add(catEstado);
      }
      DBProvider.db.insertaCatEstados(catEstados);

      //catIntegramtes
      await DBProvider.db.deleteCatIntegrantes();
      _query = _firestore.collection("catIntegrantesGrupo");
      _querySnapshot = await _query.get().timeout(_timeOutDuration);
      DBProvider.db.insertaCatIntegrantes(_querySnapshot.docs[0].data()['cantidad']);
      return true;
    }catch(e){
      print('### Error FirebaseProvider getCatalogos ### $e');
      return false;
    }
  }

  Future<List<Renovacion>> getGrupoRenovacion(int contratoId)async{
    List<Renovacion> list = List();
    try{
      _query = _firestore.collection('Renovaciones').where('contratoId', isEqualTo: contratoId);
      _querySnapshot = await _query.get().timeout(_timeOutDuration);
      for (DocumentSnapshot value in _querySnapshot.docs) {
        final renovacion = Renovacion(
          nombreCompleto    : value.data()['nombre'] != null ? value.data()['nombre'] : '${value.data()['persona']['nombre']} ${value.data()['persona']['apellido']}' ,
          capitalSolicitado : value.data()['capitalSolicitado'],
          presidente        : value.data()['presidente'] ? 1 : 0 ,
          tesorero          : value.data()['tesorero'] ? 1 : 0,
          ticket            : value.data()['ticket']
        );
        list.add(renovacion);
      }
      return list;
    }catch(e){
      return [];
    }
  }

  Future<bool>sincronizar(VoidCallback getLastGrupos)async{
    bool conexionStatus = false;
    Map<String, dynamic> sincRegistroInfo = await _sharedActions.getSincRegistroInfo();
    if(!sincRegistroInfo['Sincronizando?']){
      _sharedActions.setSincRegistroInit();
      if(!(await _utilerias.checkInternet()))
        return false;
      conexionStatus = await getCatalogos();
      conexionStatus = conexionStatus ? await _sendToFirebase(getLastGrupos) : conexionStatus;
      _sharedActions.setSincTermina();
    }else{
      print('sincronizacion en curso espere un momento !!!');
    }
    return conexionStatus;
  }

  Future<bool> _sendToFirebase(VoidCallback getLastGrupos) async{
    //validar Sincronizando
    Map<String, dynamic> userInfo = await _sharedActions.getUserInfo();

    List<Grupo> gruposPendientes = await DBProvider.db.getGruposPendientes(userInfo['uid']);
    for(Grupo e in gruposPendientes){
      if(e.contratoId > 0){ //Renovaciones
        await _sendRenovacionGrupo(e, userInfo['sistema']).then((grupoID)async{
          
          await DBProvider.db.getRenovacionesPendientesByGrupo(e.idGrupo).then((listaSolicitudes)async{
            await _sendRenovacionIntegrantesGrupo(listaSolicitudes, grupoID, e.contratoId, userInfo['sistema'], getLastGrupos);
          }).catchError((e){
            print('### Error getRenovacionesByGrupo ###');
            return false;
          });

        }).catchError((e){
          print('### Error _sendRenovacionGrupo ###');
          return false;
        });
      }else{ //Nuevas Solicitudes
        await _sendGrupo(e, userInfo['sistema']).then((grupoID)async{

          await DBProvider.db.getSolicitudesPendientesByGrupo(e.idGrupo).then((listaSolicitudes)async{
            await _sendIntegrantesGrupo(listaSolicitudes, grupoID, e.contratoId, userInfo['sistema'], getLastGrupos);
          }).catchError((e){
            print('### Error getSolicitudesPendientesByGrupo ###');
            return false;
          });

        }).catchError((e){
          print('### Error _sendGrupo ###');
          return false;
        });
      }
      
    }
    return true;
  }

  Future<String> _sendGrupo(Grupo grupo, int sistema)async{
    final firebaseGrupo = _firebaseGrupo.getFirebaseGrupo(grupo);
    if(firebaseGrupo.grupoID == null){
      Map objFirebaseGrupo = firebaseGrupo.toJson();
      objFirebaseGrupo.putIfAbsent('sistema', ()=> sistema);
      var result = await _firestore.collection("Grupos").add(objFirebaseGrupo).timeout(_timeOutDuration);
      await DBProvider.db.updateGrupoGrupoID(grupo.idGrupo, result.id);
      return result.id;
    }else{
      return firebaseGrupo.grupoID;
    }
  }

  _sendIntegrantesGrupo(List<Solicitud> solicitudes, String grupoID, int contratoId, int sistema, VoidCallback getLastGrupos)async{
    int solicitudesSubidas = 0;
    for(Solicitud solicitud in solicitudes){
    //solicitudesRenovacion.forEach((e)async{
      var firebaseSolicitud;
      Map objFirebaseSolicitud;
      
      //Solicitud solicitud = await DBProvider.db.getSolicitudById(e.idSolicitud);
      firebaseSolicitud = await _buildFirebaseSolicitud(solicitud, grupoID, Renovacion(presidente: solicitud.presidente, tesorero: solicitud.tesorero));

      if(firebaseSolicitud != null){
        firebaseSolicitud.contratoId = contratoId;
        objFirebaseSolicitud = firebaseSolicitud.toJson();
        print(firebaseSolicitud);
        //if(firebaseRenovacion.contratoId == null) objFirebaseRenovacion.putIfAbsent('contratoId', ()=> contratoId);
        objFirebaseSolicitud.putIfAbsent('sistema', ()=> sistema);
        var result = await _firestore.collection("Solicitudes").add(objFirebaseSolicitud).timeout(_timeOutDuration);
        print(result);
        solicitudesSubidas += 1;
        await DBProvider.db.updateSolicitudStatus(solicitud.idSolicitud, 1);
      }
    }
    if(solicitudesSubidas == solicitudes.length){
      await DBProvider.db.updateGrupoStatus(solicitudes[0].idGrupo, 2);
      getLastGrupos();
    }
  }

  Future<String> _sendRenovacionGrupo(Grupo renovacionGrupo, int sistema)async{
    final firebaseGrupo = _firebaseGrupo.getFirebaseGrupo(renovacionGrupo);
    if(firebaseGrupo.grupoID == null){
      Map objFirebaseGrupo = firebaseGrupo.toJson();
      objFirebaseGrupo.putIfAbsent('sistema', ()=> sistema);
      var result = await _firestore.collection("GruposRenovacion").add(objFirebaseGrupo).timeout(_timeOutDuration);
      await DBProvider.db.updateGrupoGrupoID(renovacionGrupo.idGrupo, result.id);
      return result.id;
    }else{
      return firebaseGrupo.grupoID;
    }
  }

  _sendRenovacionIntegrantesGrupo(List<Renovacion> solicitudesRenovacion, String grupoID, int contratoId, int sistema, VoidCallback getLastGrupos)async{
    int solicitudesSubidas = 0;
    for(Renovacion e in solicitudesRenovacion){
    //solicitudesRenovacion.forEach((e)async{
      var firebaseRenovacion;
      Map objFirebaseRenovacion;
      if((e.cveCli != null && e.cveCli != '') && e.status == 0){
        firebaseRenovacion = _firebaseRenovacion.getFirebaseRenovacion(e, grupoID, contratoId);
      }else{
        Solicitud solicitud = await DBProvider.db.getSolicitudById(e.idSolicitud);
        firebaseRenovacion = await _buildFirebaseSolicitud(solicitud, grupoID, e);
      }
      if(firebaseRenovacion != null){
        firebaseRenovacion.contratoId = contratoId;
        objFirebaseRenovacion = firebaseRenovacion.toJson();
        print(firebaseRenovacion);
        //if(firebaseRenovacion.contratoId == null) objFirebaseRenovacion.putIfAbsent('contratoId', ()=> contratoId);
        objFirebaseRenovacion.putIfAbsent('sistema', ()=> sistema);
        var result = await _firestore.collection("Renovaciones").add(objFirebaseRenovacion).timeout(_timeOutDuration);
        print(result);
        solicitudesSubidas += 1;
        await DBProvider.db.updateRenovacionStatus(e.idRenovacion, 1);
      }
    }
    if(solicitudesSubidas == solicitudesRenovacion.length){
      await DBProvider.db.updateGrupoStatus(solicitudesRenovacion[0].idGrupo, 2);
      getLastGrupos();
    }
  }

  Future<FirebaseSolicitud> _buildFirebaseSolicitud(Solicitud solicitud, String grupoID, Renovacion renovacion)async{
    List<Documento> documentosSolicitud = await _getDocumentos(solicitud);
    if(documentosSolicitud.length > 0){
      final persona = _firebasePersona.getFirebasePersona(solicitud);
      final direccion = _firebaseDireccion.getFirebaseDireccion(solicitud);
      _firebaseSolicitud = _firebaseSolicitud.getFirebaseSolicitud(solicitud, persona.toJson(), direccion.toJson(), documentosSolicitud, grupoID, renovacion);
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
        StorageTaskSnapshot downloadURL = await uploadTask.onComplete.timeout(_timeOutDuration);
        e.documento = await downloadURL.ref.getDownloadURL();
      }
    }catch(e){
      documentos = [];
    }
    return documentos;
  }

  actualizaTipoUsuario(String documentID)async{
    await _firestore.collection("UsuariosTipos").doc(documentID).update({"passGenerico": false});
  }
}