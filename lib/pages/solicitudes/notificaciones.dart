import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class NotificacionPage extends StatefulWidget {
  @override
  _NotificacionPageState createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  List<int> _notficaciones = [];
  bool _cargando = false;
  bool _showIcon = true;
  

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BodyContent(
        appBar: _appBar(_height),
        contenido: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              //height: 70,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Mis Mensajes'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('de mesa de crédito'.toUpperCase(), style: Constants.mensajeCentral2),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.notifications, color: Constants.primaryColor),
                      Text('0'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
                    ],
                  ),
                ],
              )
            ),
            Divider(),
            Expanded(
              child: _bodyContent()
            )
          ] 
        ),
      ),
    );
  }

  Widget _appBar(double _height){
    return CustomAppBar(
      height: _height,
      heroTag: 'logo',
      leading: !_showIcon ? Container() :
        ShakeTransition(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 40,), 
            onPressed: ()async{
              setState(() {_showIcon = false;});
              Navigator.pop(context);
            }
          )
        ),
    );
  }

  _bodyContent(){
    return _cargando ? 
    CustomCenterLoading(texto: 'Cargando información') : _showResult();
  }

  Widget _showResult(){
    return _notficaciones.length > 0 ? _lista() : _noData();
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
      child: Stack(children: [
        CustomFadeTransition(child: EmptyImage(text: 'No hay mensajes'), duration: Duration(milliseconds: 2000),),
        ListView()
      ]),
    );
  }

  Widget _lista(){
    return Container();
  }
}