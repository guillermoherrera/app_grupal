import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/models/integrantes_model.dart';
import 'package:app_grupal/providers/asesores_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/components/body_content.dart';

class RenovacionesGrupoPage extends StatefulWidget {

  const RenovacionesGrupoPage({
    Key key, 
    @required this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _RenovacionesGrupoPageState createState() => _RenovacionesGrupoPageState();
}

class _RenovacionesGrupoPageState extends State<RenovacionesGrupoPage> {
  List<Integrante> _integrantes = List();
  final _asesoresProvider = AsesoresProvider();
  final _customRoute = CustomRouteTransition();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool cargando = true;
  double capital = 0.0;

  @override
  void initState() {
    _getIntegrantes();
    super.initState();
  }

  _getIntegrantes() async{
    _integrantes.clear();
    cargando = true;
    await Future.delayed(Duration(milliseconds: 1000));
    _integrantes = await _asesoresProvider.consultaIntegrantesRenovacion(widget.params['contrato']);
    _integrantes.forEach((element) {capital += element.capital;});
    cargando = false;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image(
          image: AssetImage(Constants.logo),
          color: Colors.white,
          height: _height / 16,
          fit: BoxFit.contain,
        ),
        leading: cargando ? Container():
         ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context))),
      ),
      body: BodyContent(
        contenido: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: Colors.deepPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.params['nombre']} | ${widget.params['contrato']}'.toUpperCase(), style:  Constants.encabezadoStyle),
                  Text('Integrantes: ${_integrantes.length} | Total: \$ ${capital.toStringAsFixed(2)}'.toUpperCase(), style: Constants.subtituloStyle)
                ]
              )
            ),
            Expanded(
              child: _bodyContent()
            )
          ] 
        ),
        bottom: cargando ? Container() : _buttonRenovacion(),
      )
    );
  }

  Widget _buttonRenovacion(){
    return ShakeTransition(
      child: Container(
        width: double.infinity,
        child: CustomRaisedButton(
          action: (){},
          borderColor: Colors.blue,
          primaryColor: Colors.blue,
          textColor: Colors.white,
          label: 'Solicitar Renovacion'
        ),
      ),
    );
  }

  _bodyContent(){
    return cargando ? 
    CustomCenterLoading(texto: 'Cargando integrantes') : 
    RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_getIntegrantes(),
      child: _showResult()
    );
  }

  Widget _showResult(){
    return _integrantes.length > 0 ? _lista() : _noData();
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
      child: Stack(children: [
        EmptyImage(text: 'Sin resultados'),
        ListView()
      ]),
    );
  }

  Widget _lista(){
    List<ListTileModel> listTiles = List();
    _integrantes.forEach((integrante) {
      final listTile = ListTileModel(
        title: integrante.nombreCom,
        subtitle: '${integrante.tesorero ? 'tesorero\n' : integrante.presidente ? 'presidente\n' : ''}capital: ${integrante.capital}'.toUpperCase(),
        leading: Icon(Icons.person,),
        trailing: GestureDetector(
          onTap: (){
            //Navigator.push(context, _customRoute.crearRutaSlide(Constants.renGrupo));
          },
          child: Icon(Icons.arrow_forward_ios)
        )
      );
      listTiles.add(listTile);
    });
    
    return  ListView.builder(
            itemCount: _integrantes.length,
            itemBuilder: (context, index){
              return WidgetANimator(
                CustomListTile(
                  title: listTiles[index].title,
                  subtitle: listTiles[index].subtitle,
                  leading: listTiles[index].leading,
                  trailing: listTiles[index].trailing,
                )
              );
            }
          );
        
  }
}