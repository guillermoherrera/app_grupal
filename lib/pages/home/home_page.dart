import 'package:app_grupal/components/encabezado.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/pages/home/home_empty_page.dart';
import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/custom_drawer.dart';
import 'package:app_grupal/helpers/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.onSignIOut
  }) : super(key: key);

  final VoidCallback onSignIOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage(Constants.logo),
            color: Colors.white,
            height: _height / 16,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white, size: 30.0),
            onPressed: () => _scaffoldKey.currentState.openDrawer()
          ),
        ],
        leading: Container(),
      ),
      drawer: CustomDrawer(),
      body: BodyContent(
        encabezado: _createTabViewHead(_height),
        contenido: _createTabView()
      ),
      
      bottomNavigationBar: TabBar(
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        labelColor: Colors.blue,
        unselectedLabelColor: Color.fromRGBO(116, 117, 152, 1.0),
        controller: _tabController,
        tabs: _createTabs()
      ),//_bottomNavigationBar(context),
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
        HomeEmptyPage(),
        RenovacionesPage()
      ],
      controller: _tabController,
    );
  }

  Widget _createTabViewHead(double height) {
    return SizedBox(
      height: height / 13,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Encabezado(icon: Icons.check_circle, encabezado: 'Bienvenido', subtitulo: 'Subtitulos'),
          Encabezado(icon: Icons.archive, encabezado: 'Renovaciones', subtitulo: 'Subtitulos'),
        ],
        controller: _tabController,
      ),
    );
  }
}