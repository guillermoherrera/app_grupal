import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';


class InfoPage extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: BodyContent(
        appBar: _appBar(_height, context),
        contenido: _content(), 
        //bottom: _buttons(),
      ),
    );
  }

  Widget _appBar(double _height, BuildContext context){
    return CustomAppBar(
      height: _height,
      heroTag: '',
      leading: ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios, size: 40.0,), onPressed: ()=>Navigator.pop(context))),
    );
  }

  Widget _content(){
    return Container(
      color: Constants.primaryColor,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(tag: 'info', child: Icon(Icons.info, color: Colors.white, size: 40.0,)),
            _texto(),
          ],
        )
      ),
    );
  }

  Widget _texto(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              Constants.info1.toUpperCase(),
              style: Constants.subtituloStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            child: Text(
              Constants.info2.toUpperCase(),
              style: Constants.subtituloStyle,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

}