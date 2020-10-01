import 'package:app_grupal/components/encabezado.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/pages/home/home_dashboard.dart';
import 'package:app_grupal/pages/home/home_empty_page.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';

class HomeContent extends StatefulWidget {
  
  const HomeContent({
    Key key, 
    this.scaffoldKey,
    this.uid
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String uid;

  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Grupo> _ultimosq15Grupos = List();
  List<Grupo> _gruposSinEnviar = List();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _getLastGrupos();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getLastGrupos()async{
    _ultimosq15Grupos = await DBProvider.db.getLastGrupos(widget.uid);
    _gruposSinEnviar = _ultimosq15Grupos.where((e) => e.status == 1).toList();
    if(_ultimosq15Grupos.length > 0) setState((){});
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
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: Icon(Icons.account_circle, size: 30.0),
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
        icon: Icon(Icons.cached),
        text: 'RENOVACIÓNES',
        iconMargin: EdgeInsets.all(0),
      )
    ];
  }

  Widget _createTabView() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        _ultimosq15Grupos.isEmpty ? HomeEmptyPage() : HomeDashboardPage(grupos: _ultimosq15Grupos, scaffoldKey: widget.scaffoldKey),
        RenovacionesPage()
      ],
      controller: _tabController,
    );
  }

  Widget _createTabViewHead(double height) {
    return SizedBox(
      height: 85,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Encabezado(
            icon: _gruposSinEnviar.isEmpty ? Icons.check_circle_outline : Icons.error_outline,
            encabezado: _gruposSinEnviar.isEmpty ? 'Hola, bienvenido' : 'Hay Grupos pendientes', 
            subtitulo: _gruposSinEnviar.isEmpty ? 'Selecciona una opción en el menu de la barra inferior' : 'Tienes ${_gruposSinEnviar.length} grupo(s) pendiente(s) de enviar'),
          Encabezado(icon: Icons.assignment, encabezado: 'Renovaciones', subtitulo: 'Grupos proximos a liquidar.'),
        ],
        controller: _tabController,
      ),
    );
  }
}