import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/card_swiper.dart';
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
            SizedBox(height: 10.0,),
            Text('Versión 1.0'.toUpperCase(), style: Constants.encabezadoStyle,),
            CardSwiper(
              listItems: _itemsCard(),
            )
          ],
        )
      ),
    );
  }

  List<Widget>_itemsCard(){
    List<Widget> list = List();
    for (var i = 0; i < 2; i++) {
      list.add(
        Container(
          padding: EdgeInsets.all(10.0),
          color: Color(0xffBCEA84).withOpacity(0.95),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${i == 0 ? 'App Asesores' : 'Funciones'}'.toUpperCase(), style: Constants.mensajeInfo),
              SizedBox(height: 10.0,),
              i == 0 ? Image(
                image: AssetImage(Constants.logo),
                color: Constants.primaryColor,
                height: 100,
                fit: BoxFit.contain,
              ) : Icon(Icons.settings, size: 40.0, color: Constants.primaryColor,) ,
              Text(
                '${i == 0 ? Constants.info1 : Constants.info2}'.toUpperCase(),
                style: Constants.mensajeCentral,
              )
            ],
          ),
        )
      );
    }
    return list;
  }
}