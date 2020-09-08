import 'package:flutter/material.dart';

import 'package:app_grupal/pages/home/home_content.dart';
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

class _HomePageState extends State<HomePage>{
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
      drawerEnableOpenDragGesture: false,
      body: HomeContent(),
    );
  }
}