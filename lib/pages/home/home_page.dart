import 'package:flutter/material.dart';

import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/classes/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
    this.onSignIOut
  }) : super(key: key);

  final VoidCallback onSignIOut;
  final AuthFirebase _authFirebase = new AuthFirebase();
  final SharedActions _sharedActions = new SharedActions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('logueado'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: ()async{
              await _authFirebase.signOut();
              _sharedActions.clear();
              onSignIOut();
              //Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            })
        ],
      ),
      body: Center(
        child: Container(
          child: Text('logueado'),
        ),
      ),
    );
  }
}