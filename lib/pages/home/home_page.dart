import 'package:app_grupal/classes/shared_preferences.dart';
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
  SharedActions _sharedActions = SharedActions();
  Map<String, dynamic> userInfo = {'name': 'Asesor', 'user': 'Usuario'};

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  _getUserInfo() async{
    userInfo = await _sharedActions.getUserInfo();
    setState(() {});
    print(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(userInfo: userInfo),
      drawerEnableOpenDragGesture: false,
      body: HomeContent(scaffoldKey: _scaffoldKey),
    );
  }
}