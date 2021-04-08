import 'dart:async';

import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/components/encabezado.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/grupos_model.dart';
//import 'package:app_grupal/pages/cartera/cartera_page.dart';
import 'package:app_grupal/pages/home/home_dashboard.dart';
import 'package:app_grupal/pages/home/home_empty_page.dart';
//import 'package:app_grupal/pages/renovaciones/renovaciones.dart';
import 'package:app_grupal/pages/solicitudes/solicitudes_page.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/providers/vcapi_provider.dart';
//import 'package:app_grupal/providers/firebase_provider.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';

class HomeContent extends StatefulWidget {
  
  const HomeContent({
    Key key, 
    this.scaffoldKey
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  SharedActions _sharedActions = SharedActions();
  //final _firebaseProvider = FirebaseProvider();
  final VCAPIProvider _vcapiProvider = new VCAPIProvider();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;
  List<Grupo> _ultimosq15Grupos = List();
  List<Grupo> _gruposSinEnviar = List();
  String uid;
  Map<String, dynamic> info;
  bool cargando = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _getParamsFromAPi();
    _getLastGrupos();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getParamsFromAPi()async{
    print(' ^^^ consultaParams inicio ^^^ ');
    _vcapiProvider.consultaParamsApp();
    final syncTime =  Duration(milliseconds: 300000);
    await Future.delayed(syncTime);
    new Timer.periodic(syncTime, (t) async{
      if(this.mounted){
        setState((){cargando = true;});
        print(' ^^^ consultaParams programado ${DateTime.now()} ^^^ ');
        await _vcapiProvider.consultaParamsApp();
        setState((){cargando = false;});
      }else{
        t.cancel();
      }
    });
  }

  _getLastGrupos()async{
    await Future.delayed(Duration(milliseconds: 1000));
    uid = await _sharedActions.getUserId();
    info = await _sharedActions.getUserInfo();
    _ultimosq15Grupos = await DBProvider.db.getLastGrupos(uid);
    _gruposSinEnviar = _ultimosq15Grupos.where((e) => e.status == 1).toList();
    if(this.mounted) setState((){cargando = false;});
    //if(_ultimosq15Grupos.length > 0) setState((){});
  }

  Future<bool> _sincroniza()async{
    print('Sincronizaion a Firebase deshabilitada');
    return true;
    //return await _firebaseProvider.sincronizar(_getLastGrupos);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return BodyContent(
      appBar: _appBar(_height),
      encabezado: _createTabViewHead(_height),
      contenido: _createTabView(),
      bottom: Container(
        color: Constants.defaultColor,
        child: TabBar(
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          labelColor: Colors.blue,
          unselectedLabelColor: Color.fromRGBO(116, 117, 152, 1.0),
          controller: _tabController,
          tabs: _createTabs()
        ),
      )
    );
  }

  Widget _appBar(double _height){
    return CustomAppBar(
      height: _height,
      heroTag: 'logo',
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: IconButton(
            icon: Icon(Icons.account_circle, size: 40.0),
            onPressed: () => widget.scaffoldKey.currentState.openDrawer()
          ),
        )
      ],
      leading: Container()
    );
  }

  List<Widget> _createTabs() {
    return [
      Tab(
        icon: Icon(Icons.home),
        text: 'INICIO',
        iconMargin: EdgeInsets.all(0),
      ),
      Tab(
        icon: Icon(Icons.group),
        text: 'GRUPOS',
        iconMargin: EdgeInsets.all(0),
      ),
      /*Tab(
        icon: Icon(Icons.account_balance_wallet),
        text: 'CARTERA',
        iconMargin: EdgeInsets.all(0),
      ),
      Tab(
        icon: Icon(Icons.cached),
        text: 'RENOVACION',
        iconMargin: EdgeInsets.all(0),
      )*/
    ];
  }

  Widget _createTabView() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        cargando ? CustomCenterLoading(texto: 'Iniciando App') : 
          _ultimosq15Grupos.isEmpty ? _emptyPage() : HomeDashboardPage(grupos: _ultimosq15Grupos, scaffoldKey: widget.scaffoldKey, getLastGrupos: ()=>_getLastGrupos(), sincroniza: _sincroniza),
        SolicitudesPage(getLastGrupos: ()=>_getLastGrupos(), sincroniza: _sincroniza),
        //CarteraPage(),
        //RenovacionesPage(getLastGrupos: ()=>_getLastGrupos(), sincroniza: _sincroniza),
      ],
      controller: _tabController,
    );
  }

  Widget _emptyPage(){
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_getLastGrupos(),
      child: HomeEmptyPage(sincroniza: _sincroniza, scaffoldKey: widget.scaffoldKey, info: info)
    );
  }

  Widget _createTabViewHead(double height) {
    return SizedBox(
      height: 85,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Encabezado(
            icon: cargando ? Icons.watch_later : _gruposSinEnviar.isEmpty ? Icons.check_circle_outline : Icons.error_outline,
            encabezado: cargando ? 'Iniciando App' : _gruposSinEnviar.isEmpty ? 'Créditos Grupales' : 'Hay Grupos pendientes', 
            subtitulo: cargando ? 'Cargando información' : _gruposSinEnviar.isEmpty ? 'grupo confia' : 'Tienes ${_gruposSinEnviar.length} grupo(s) pendiente(s) de enviar'),
          Encabezado(icon: Icons.group, encabezado: 'Grupos', subtitulo: 'Selacciona una opción.'),
          //Encabezado(icon: Icons.assignment, encabezado: 'Cartera', subtitulo: 'Grupos en mi cartera.'),
          //Encabezado(icon: Icons.assignment, encabezado: 'Renovaciones', subtitulo: 'Grupos proximos a liquidar.'),
        ],
        controller: _tabController,
      ),
    );
  }
}