import 'package:flutter/material.dart';

import 'package:app_grupal/pages/home/home_content.dart';
import 'package:app_grupal/components/custom_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.onSignIOut
  }) : super(key: key);

  final VoidCallback onSignIOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      drawerEnableOpenDragGesture: false,
      body: HomeContent(scaffoldKey: _scaffoldKey),
    );
  }
}