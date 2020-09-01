import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class RenovacionesPage extends StatefulWidget {
  @override
  _RenovacionesPageState createState() => _RenovacionesPageState();
}

class _RenovacionesPageState extends State<RenovacionesPage> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20.0),
              Text('Cargando Renovaciones'.toUpperCase())
            ],
          ),
        ),
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _floatingButton(){
    return FloatingActionButton(
      backgroundColor: Constants.primaryColor,
      onPressed: (){},
      child: Icon(Icons.calendar_today),
    );
  }

  @override
  bool get wantKeepAlive => true;
}