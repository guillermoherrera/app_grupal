import 'dart:io';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/grupos_model.dart';
export 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/models/renovacion_model.dart';
export 'package:app_grupal/models/renovacion_model.dart';
import 'package:app_grupal/models/documentos_model.dart';
export 'package:app_grupal/models/documentos_model.dart';
import 'package:app_grupal/models/cat_documentos_model.dart';
export 'package:app_grupal/models/cat_documentos_model.dart';
import 'package:app_grupal/models/cat_estados_model.dart';
export 'package:app_grupal/models/cat_estados_model.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'GrupalDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate:  (Database db, int version)async{
        await createCatDocumentosTable(db);
        await createCatIntegrantesTable(db);
        await createCatEstadosTable(db);
        await createSolicitudesTable(db);
        await createDocumentosSolicitudTable(db);
        await createGruposTable(db);
        await createRenovacionesTable(db);
      }
    );
  }

  Future<void> createCatDocumentosTable(Database db)async{
    final sql = '''CREATE TABLE ${Constants.catDocumentosTable} (
      ${Constants.tipo} INTEGER PRIMARY KEY,
      ${Constants.descDocumento} TEXT
    )''';

    await db.execute(sql);
  }

  Future<void> createCatIntegrantesTable(Database db) async{
    final catIntegrantes = '''CREATE TABLE ${Constants.catIntegrantesTable}(
      ${Constants.cantidadIntegrantes} INTEGER
    )''';

    await db.execute(catIntegrantes);
  }

  Future<void> createCatEstadosTable(Database db) async{
    final catEstados = '''CREATE TABLE ${Constants.catEstadosTable}(
      ${Constants.estado} TEXT,
      ${Constants.codigo} TEXT
    )''';

    await db.execute(catEstados);
  }

  Future<void> createSolicitudesTable(Database db)async{
    final solicitudesSql = '''CREATE TABLE ${Constants.solicitudesTable} (
      ${Constants.idSolicitud} INTEGER PRIMARY KEY,
      ${Constants.idGrupo} INTEGER,
      ${Constants.nombreGrupo} TEXT,
      ${Constants.capital} DOUBLE,
      ${Constants.nombre} TEXT,
      ${Constants.segundoNombre} TEXT,
      ${Constants.primerApellido} TEXT,
      ${Constants.segundoApellido} TEXT,
      ${Constants.fechaNacimiento} INTEGER,
      ${Constants.curp} TEXT,
      ${Constants.rfc} TEXT,
      ${Constants.telefono} TEXT,
      ${Constants.status} INTEGER,
      ${Constants.tipoContrato} INTEGER,
      ${Constants.userID} TEXT,
      ${Constants.documentID} TEXT,
      ${Constants.presidente} INTEGER,
      ${Constants.tesorero} INTEGER,
      
      ${Constants.direccion1} TEXT,
      ${Constants.coloniaPoblacion} TEXT,
      ${Constants.delegacionMunicipio} TEXT,
      ${Constants.ciudad} TEXT,
      ${Constants.estado} TEXT,
      ${Constants.cp} INTEGER,
      ${Constants.pais} TEXT,
      ${Constants.fechaCaptura} INTEGER,
      ${Constants.contratoId} INTEGER
    )''';
    
    await db.execute(solicitudesSql);
  }

  Future<void> createDocumentosSolicitudTable(Database db)async{
    final solicitudesSql = '''CREATE TABLE ${Constants.documentoSolicitudesTable} (
      ${Constants.idDocumentoSolicitudes} INTEGER PRIMARY KEY,
      ${Constants.idSolicitud} INTEGER,
      ${Constants.tipoDocumento} INTEGER,
      ${Constants.documento} TEXT,
      ${Constants.version} INT,
      ${Constants.cambioDoc} INT,
      ${Constants.observacionCambio} TEXT
    )''';
    
    await db.execute(solicitudesSql);
  }

  Future<void> createGruposTable(Database db)async{
    final solicitudesSql = '''CREATE TABLE ${Constants.gruposTable} (
      ${Constants.idGrupo} INTEGER PRIMARY KEY,
      ${Constants.nombreGrupo} TEXT,
      ${Constants.status} INTEGER,
      ${Constants.userID} TEXT,
      ${Constants.grupoID} TEXT,
      ${Constants.importeGrupo} DOUBLE,
      ${Constants.cantidadSolicitudes} INTEGER,
      ${Constants.contratoId} INTEGER
    )''';
    
    await db.execute(solicitudesSql);
  }

  Future<void> createRenovacionesTable(Database db) async{
    final sql = '''CREATE TABLE ${Constants.renovacionesTable}(
      ${Constants.idRenovacion} INTEGER PRIMARY KEY,
      ${Constants.idGrupo} INTEGER,
      ${Constants.idSolicitud} INTEGER,
      ${Constants.nombreGrupo} TEXT,
      ${Constants.importe} DOUBLE,
      ${Constants.nombreCompleto} TEXT,
      ${Constants.noCda} INT,
      ${Constants.cveCli} TEXT,
      ${Constants.capital} DOUBLE,
      ${Constants.diasAtraso} INT,
      ${Constants.beneficio} TEXT,
      ${Constants.ticket} TEXT,
      ${Constants.status} INT,
      ${Constants.userID} TEXT,
      ${Constants.tipoContrato} INT,
      ${Constants.nuevoCapital} DOUBLE,
      ${Constants.telefono} TEXT,
      ${Constants.presidente} INTEGER,
      ${Constants.tesorero} INTEGER
    )''';

    await db.execute(sql);
  }
  
  //Repositorio CatIntegrantes
  Future<int> getCatIntegrantesCant()async{
    final db = await database;
    final res = await db.query(Constants.catIntegrantesTable);
    return res.isNotEmpty ? res[0]['cantidadIntegrantes'] : 100;
  }

  //Repositorio CatDocumentos
  Future<void> insertaCatDocumentos(List<CatDocumento> catDocumentos)async{
    final db = await database;
    List<int> res = List();
    for(CatDocumento e in catDocumentos){
    //catDocumentos.forEach((e) async{
      try{
        final id = await db.insert(Constants.catDocumentosTable,  e.toJson());
        res.add(id);
      }catch(e){
        print('### Error DBprovider insertaDocumentos ### $e');
      }
    }
    return res;
  }

  Future<void> deleteCatDocumentos()async{
    final db = await database;
    final res = await db.delete(Constants.catDocumentosTable);
    return res;
  }

  Future<List<CatDocumento>> getDocumentos() async{
    final db = await database;
    final res = await db.query(Constants.catDocumentosTable);
    List<CatDocumento> list = res.isNotEmpty ? res.map((e) => CatDocumento.fromjson(e)).toList() : [];
    return list;
  }

  //Repositorio CatEstados
  Future<void> insertaCatEstados(List<CatEstado> catEstados)async{
    final db = await database;
    List<int> res = List();
    for(CatEstado e in catEstados){
    //catEstados.forEach((e) async{
      try{
        final id = await db.insert(Constants.catEstadosTable,  e.toJson());
        res.add(id);
      }catch(e){
        print('### Error DBprovider insertaCatEstados ### $e');
      }
    }
    return res;
  }

  Future<List<CatEstado>> getCatEstados() async{
    final db = await database;
    final res = await db.query(Constants.catEstadosTable);
    List<CatEstado> list = res.isNotEmpty ? res.map((e) => CatEstado.fromjson(e)).toList() : [];
    return list;
  }

  Future<void> deleteCatEstados()async{
    final db = await database;
    final res = await db.delete(Constants.catEstadosTable);
    return res;
  }

  //Repositorio CatIntegrantes
  Future<void> insertaCatIntegrantes(int cantIntegrantes)async{
    final db = await database;
    final res = await db.insert(Constants.catIntegrantesTable,  {Constants.cantidadIntegrantes : cantIntegrantes});
    return res;
  }

  Future<void> deleteCatIntegrantes()async{
    final db = await database;
    final res = await db.delete(Constants.catIntegrantesTable);
    return res;
  }
  
  //Repositorio Grupos
  Future<int> nuevoGrupo( Grupo grupo) async{
    //validar nombre del grupo
    final db = await database;
    final res = await db.insert(Constants.gruposTable, grupo.toJson());
    return res;
  }

  Future<Grupo> getGrupoById(int id) async{
    final db = await database;
    final res = await db.query(Constants.gruposTable, where: '${Constants.idGrupo} = ?', whereArgs: [id]);
    return res.isNotEmpty ? Grupo.fromjson(res.first) : null;
  }

  Future<List<Grupo>> getGrupos() async{
    final db = await database;
    final res = await db.query(Constants.gruposTable);
    List<Grupo> list = res.isNotEmpty ? res.map((e) => Grupo.fromjson(e)).toList() : [];
    return list;
  }

  Future<List<Grupo>> getLastGrupos(String uid) async{
    final db = await database;
    final res = await db.query(Constants.gruposTable, where: '${Constants.userID} = ?', whereArgs: [uid], orderBy: '${Constants.idGrupo} DESC', limit: 15);
    List<Grupo> list = res.isNotEmpty ? res.map((e) => Grupo.fromjson(e)).toList() : [];
    return list;
  }

  Future<List<Grupo>> getGruposPendientes(String uid)async{
    final db = await database;
    final res = await db.query(Constants.gruposTable, where: '${Constants.userID} = ? AND ${Constants.status} = ?', whereArgs: [uid, 1], orderBy: '${Constants.idGrupo} DESC', limit: 15);
    List<Grupo> list = res.isNotEmpty ? res.map((e) => Grupo.fromjson(e)).toList() : [];
    return list;
  }

  Future<int> updateGrupoStatus(int idGrupo, int status)async{
    final db = await database;
    final res = db.update(Constants.gruposTable, {'${Constants.status}': status}, where: '${Constants.idGrupo} = ?', whereArgs: [idGrupo]);
    return res;
  }

  Future<int> updateGrupoGrupoID(int idGrupo, String grupoID)async{
    final db = await database;
    final res = db.update(Constants.gruposTable, {'${Constants.grupoID}': grupoID});
    return res;
  }

  //Repositorio Solicitudes Integrantes
  Future<int> nuevaSolicitud(Solicitud solicitud)async{
    final db = await database;
    final res = await db.insert(Constants.solicitudesTable, solicitud.toJson());
    return res;
  }

  Future<List<Solicitud>> getSolicitudesByContrato(int contratoId)async{
    final db = await database;
    final res = await db.query(Constants.solicitudesTable, where: '${Constants.contratoId} = ?', whereArgs: [contratoId]);
    List<Solicitud> list = res.isNotEmpty ? res.map((e) => Solicitud.fromjson(e)).toList() : [];
    return list;
  }

  Future<List<Solicitud>> getSolicitudesByGrupo(int idGrupo)async{
    final db = await database;
    final res = await db.query(Constants.solicitudesTable, where: '${Constants.idGrupo} = ?', whereArgs: [idGrupo]);
    List<Solicitud> list = res.isNotEmpty ? res.map((e) => Solicitud.fromjson(e)).toList() : [];
    return list;
  }

  Future<Solicitud> getSolicitudById(int id)async{
    final db = await database;
    final res = await db.query(Constants.solicitudesTable, where: '${Constants.idSolicitud} = ?', whereArgs: [id]);
    return res.isNotEmpty ? Solicitud.fromjson(res.first) : null;
  }

  //Repositorio Docuementos Solicitudes
  Future<int> nuevoDocumento(Documento documento)async{
    final db = await database;
    final res = await db.insert(Constants.documentoSolicitudesTable, documento.toJson());
    return res;
  }

  Future<List<Documento>> getDocumentosbySolicitud(int idSolicitud)async{
    final db = await database;
    final res = await db.query(Constants.documentoSolicitudesTable, where: '${Constants.idSolicitud} = ?', whereArgs: [idSolicitud]);
    
    List<Documento> list = res.isNotEmpty ? res.map((e) => Documento.fromjson(e)).toList() : [];
    return list;
  }

  //Repositorio Renovaciones
  Future<List<Renovacion>> getRenovacionesByContrato(int contratoId) async{
    final db = await database;
    final grupo = await db.query(Constants.gruposTable, where: '${Constants.contratoId} = ?', whereArgs: [contratoId]);
    final int idGrupo = grupo.isNotEmpty ? Grupo.fromjson(grupo.first).idGrupo : 0;
    final res = await db.query(Constants.renovacionesTable, where: '${Constants.idGrupo} = ?', whereArgs: [idGrupo]);
    
    List<Renovacion> list = res.isNotEmpty ? res.map((e) => Renovacion.fromjson(e)).toList() : [];
    return list;
  }

  Future<List<Renovacion>> getRenovacionesPendientesByGrupo(int idGrupo) async{
    final db = await database;
    final res = await db.query(Constants.renovacionesTable, where: '${Constants.idGrupo} = ? AND ${Constants.status} = 0', whereArgs: [idGrupo]);
    
    List<Renovacion> list = res.isNotEmpty ? res.map((e) => Renovacion.fromjson(e)).toList() : [];
    return list;
  }
  
  Future<void> nuevasRenovaciones(List<Renovacion> renovaciones, List<bool> renovacionesCheck)async{
    final db = await database;
    List<int> res = List();
    int i = 0;
    for(Renovacion r in renovaciones){
    //renovaciones.asMap().forEach((i,r)async{
      try{
        if(renovacionesCheck[i]){
          final id = await db.insert(Constants.renovacionesTable,  r.toJson());
          res.add(id);
        }
      }catch(e){
        print('### Error DBprovider nuevasRenovaciones ### ${r.nombreCompleto} $e');
      }
      i++;
    }
    return res;
  }

  Future<int> updateRenovacionStatus(int idRenovacion, int status)async{
    final db = await database;
    final res = db.update(Constants.renovacionesTable, {'${Constants.status}': status}, where:'${Constants.idRenovacion} = ?', whereArgs: [idRenovacion]);
    return res;
  }
}