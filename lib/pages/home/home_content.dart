import 'package:app_grupal/components/encabezado.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/home/home_empty_page.dart';
import 'package:app_grupal/pages/renovaciones/renovaciones.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return BodyContent(
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
          Encabezado(icon: Icons.assignment, encabezado: 'Renovaciones', subtitulo: 'Grupos proximos a liquidar.'),
        ],
        controller: _tabController,
      ),
    );
  }
}