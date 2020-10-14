import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class CarteraIntegrantePage extends StatefulWidget {
  const CarteraIntegrantePage({
    Key key,
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _CarteraIntegrantePageState createState() => _CarteraIntegrantePageState();
}

class _CarteraIntegrantePageState extends State<CarteraIntegrantePage> {
  bool _cargando = true;
  bool _showIcon = true;
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BodyContent(
            appBar: _appBar(_height),
            contenido: _bodyContent(),
          )
        ],
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
    return !_cargando ? 
    CustomCenterLoading(texto: 'Cargando información') : _showResult();
  }

  Widget _showResult(){
    return false ? _infoView() : _noData();
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
      child: Stack(children: [
        CustomFadeTransition(child: EmptyImage(text: 'Sin resultados'), duration: Duration(milliseconds: 2000),),
        ListView()
      ]),
    );
  }

  Widget _infoView(){
    return Container(
      height: 200,
      color: Colors.red,
    );
  }
}