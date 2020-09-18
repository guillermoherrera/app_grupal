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
  List<bool> _integranteCheck = new List<bool>();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _cargando = true;
  double _capital = 0.0;
  bool _renovadoCheck = true;

  @override
  void initState() {
    _getIntegrantes();
    super.initState();
  }

  _getIntegrantes() async{
    _integrantes.clear();
    _integranteCheck.add(true);
    _cargando = true;
    await Future.delayed(Duration(milliseconds: 1000));
    _integrantes = await _asesoresProvider.consultaIntegrantesRenovacion(widget.params['contrato']);
    if(_integrantes.length > 0) _renovadoCheck = _integrantes[0].renovado; 
    _integrantes.forEach((element) {
      _capital += element.capital;
      _integranteCheck.add(true);
    });
    _cargando = false;
    if(this.mounted) setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BodyContent(
        appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image(
          image: AssetImage(Constants.logo),
          color: Colors.white,
          height: _height / 16,
          fit: BoxFit.contain,
        ),
        leading: _cargando ? Container():
         ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context))),
      ),
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
                      Text('${widget.params['nombre']} | ${widget.params['contrato']}'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('Integrantes: ${_integrantes.length}'.toUpperCase(), style: Constants.mensajeCentral2),
                      Text('Total: \$ ${_capital.toStringAsFixed(2)}'.toUpperCase(), style: Constants.mensajeCentral3),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.group, color: Constants.primaryColor),
                      Text('Estatus: ${widget.params['status']}'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
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
        bottom: _cargando ? Container() : _buttonRenovacion(),
      ),
      floatingActionButton: _cargando ? null : 
      ShakeTransition(axis: Axis.vertical, duration: Duration(milliseconds: 2000) ,child: _floatingButton(_height))
    );
  }

  Widget _floatingButton(double height){
    return _renovadoCheck ? 
    Container(
      padding: EdgeInsets.only(bottom: height / 16),
      child: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        onPressed: null,
        child: Icon(Icons.check),
      ),
    ):
    Container(
      padding: EdgeInsets.only(bottom: height / 16),
      child: FloatingActionButton(
        //backgroundColor: Constants.primaryColor,
        onPressed: (){},
        child: Icon(Icons.person_add),
      ),
    );
  }

  Widget _buttonRenovacion(){
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 50,
        ),
        ShakeTransition(
          child: Container(
            decoration: BoxDecoration(
                color: _renovadoCheck ? Constants.primaryColor : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
            width: double.infinity,
            height: 50,
            child: CustomRaisedButton(
              action: (){},
              borderColor: _renovadoCheck ? Constants.primaryColor : Colors.blue,
              primaryColor: _renovadoCheck ? Constants.primaryColor : Colors.blue,
              textColor: Colors.white,
              label: _renovadoCheck ? 'Renovado' : 'Solicitar Renovación'
            ),
          ),
        ),
      ],
    );
  }

  _bodyContent(){
    return _cargando ? 
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
    _integrantes.asMap().forEach((index, integrante) {
      final listTile = ListTileModel(
        title: Text(
          integrante.nombreCom, 
          style: _integranteCheck[index] ? Constants.mensajeCentral : Constants.mensajeCentralNot, 
          overflow: TextOverflow.ellipsis
        ),
        subtitle: '${integrante.tesorero ? 'tesorero\n' : integrante.presidente ? 'presidente\n' : ''}capital: ${integrante.capital}'.toUpperCase(),
        leading: Checkbox(
          value: _integranteCheck[index],
          onChanged: (bool val){
            itemChange(val, index);
          }
        ),
        trailing: Icon(_integranteCheck[index] ? Icons.arrow_forward_ios : Icons.highlight_off, color: _integranteCheck[index] ? Constants.primaryColor : Colors.grey),
      );
      listTiles.add(listTile);
    });
    
    return  MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _integrantes.length + 1,
        itemBuilder: (context, index){
          if(index == _integrantes.length)
            return SizedBox(height: 50.0);
          return WidgetANimator(
            GestureDetector(
              onTap: (){
                final json = {
                  'nombreCom'  : _integrantes[index].nombreCom,
                  'cveCli'     : _integrantes[index].cveCli,
                  'telefonoCel': _integrantes[index].telefonoCel,
                  'importeT'   : _integrantes[index].importeT,
                  'diaAtr'     : _integrantes[index].diaAtr,
                  'capital'    : _integrantes[index].capital,
                  'noCda'      : _integrantes[index].noCda,
                  'tesorero'   : _integrantes[index].tesorero,
                  'presidente' : _integrantes[index].presidente
                };
                if(_integranteCheck[index]) Navigator.push(context, _customRoute.crearRutaSlide(Constants.renIntegrante, json));
              },
              child: CustomListTile(
                title: listTiles[index].title,
                subtitle: listTiles[index].subtitle,
                leading: _renovadoCheck ? null : listTiles[index].leading,
                trailing: _renovadoCheck ? null : listTiles[index].trailing,
              ),
            )
          );
        }
      ),
    );
  }
  
  void itemChange(bool val,int index){
    setState(() {
      _integranteCheck[index] = val;
    });
  }
}