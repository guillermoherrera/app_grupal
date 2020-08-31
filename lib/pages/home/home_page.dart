import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/custom_drawer.dart';
import 'package:app_grupal/helpers/constants.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
    this.onSignIOut
  }) : super(key: key);

  final VoidCallback onSignIOut;

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
        icon: Icons.check_circle,
        encabezado: 'Encabezado Texto', 
        subtitulo: 'Subtitulo Texto',
        contenido: _contenidoHome()
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _contenidoHome(){
    return ListView(
      children: [
        Image(
          image: AssetImage(Constants.homeImage),
          fit: BoxFit.contain,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child:Text(
            'Bienvenido a Asesores App.',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)
          )
        ),
        Container(
          padding: EdgeInsets.all(20),
          child:Text(
            Constants.homeText,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15),
          )
        )
      ],
    );
  }

  _bottomNavigationBar(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white10,
        primaryColor: Constants.primaryColor,
        textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Color.fromRGBO(116, 117, 152, 1.0)))
      ),
      child: BottomNavigationBar(
        elevation: 40.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0,),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cached, size: 30.0,),
            title: Container()
          )
        ] 
      )
    );
  }

}