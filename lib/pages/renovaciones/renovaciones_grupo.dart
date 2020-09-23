import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
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
  final _asesoresProvider = AsesoresProvider();
  final _customRoute = CustomRouteTransition();
  final _sharedActions = SharedActions();
  final _customSnakBar = new CustomSnakBar();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Integrante> _integrantes = List();
  List<bool> _integranteCheck = List<bool>();
  List<Renovacion> _renovacionIntegrantes = List();
  bool _cargando = true;
  double _capital = 0.0;
  bool _renovadoCheck = true;
  String userID;

  @override
  void initState(){
    _getIntegrantesFromConfia();
    super.initState();
  }

  _geIntegrantesFromSqlite() async{

  }

  _getIntegrantesFromConfia() async{
    _integrantes.clear();
    _integranteCheck.clear();
    _capital = 0.0;

    //_integranteCheck.add(true);
    await Future.delayed(Duration(milliseconds: 1000));
    _integrantes = await _asesoresProvider.consultaIntegrantesRenovacion(widget.params['contrato']);
    if(_integrantes.length > 0) _renovadoCheck = _integrantes[0].renovado; 
    _integrantes.forEach((integrante) {
      _capital += integrante.capital;
      _integranteCheck.add(true);
      
      Renovacion renovacion = Renovacion(
        capital       : integrante.capital,
        cveCli        : integrante.cveCli,
        noCda         : integrante.noCda,
        diasAtraso    : integrante.diaAtr,
        importe       : integrante.importeT,
        nombreCompleto: integrante.nombreCom,
        nuevoCapital  : integrante.capital,
        presidente    : integrante.presidente ? 1 : 0,
        tesorero      : integrante.tesorero ? 1 : 0,
        telefono      : integrante.telefonoCel,
        status        : 0,
        nombreGrupo   : widget.params['nombre'],
        tipoContrato  : 2 
      );  
      _renovacionIntegrantes.add(renovacion);
    });
    
    _cargando = false;
    if(this.mounted) setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
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
        actions: [
          _cargando ? Container(): 
          _renovadoCheck ? Container():
          ShakeTransition(child: Container(padding: EdgeInsets.symmetric(horizontal: 10.0), child: IconButton(icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 30.0),onPressed: () => {}))),
        ],
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
                      Text('Integrantes: ${_renovacionIntegrantes.length}'.toUpperCase(), style: Constants.mensajeCentral2),
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
      //floatingActionButton: _cargando ? null : 
      //ShakeTransition(axis: Axis.vertical, duration: Duration(milliseconds: 2000) ,child: _floatingButton(_height))
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
              action: _renovadoCheck ? null : () async => _solicitarRenovacion(),
              borderColor: _renovadoCheck ? Constants.primaryColor : Colors.blue,
              primaryColor: _renovadoCheck ? Constants.primaryColor : Colors.blue,
              textColor: Colors.white,
              label: _renovadoCheck ? 'Renovación Solicitada' : 'Solicitar Renovación'
            ),
          ),
        ),
      ],
    );
  }

  _bodyContent(){
    return _cargando ? 
    CustomCenterLoading(texto: 'Cargando integrantes') : _showResult(); 
    //_renovadoCheck ? _showResult() :RefreshIndicator(
    //  key: _refreshKey,
    //  onRefresh: () => _getIntegrantesFromConfia(),
    //  child: _showResult()
    //);
  }

  Widget _showResult(){
    return _renovacionIntegrantes.length > 0 ? _lista() : _noData();
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
    _renovacionIntegrantes.asMap().forEach((index, integrante) {
      final listTile = ListTileModel(
        title: Text(
          integrante.nombreCompleto, 
          style: _integranteCheck[index] ? Constants.mensajeCentral : Constants.mensajeCentralNot, 
          overflow: TextOverflow.ellipsis
        ),
        subtitle: '${integrante.tesorero == 1 ? 'tesorero\n' : integrante.presidente == 1 ? 'presidente\n' : ''}capital: ${integrante.capital}'.toUpperCase(),
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
        itemCount: _renovacionIntegrantes.length,// + 1,
        itemBuilder: (context, index){
          //if(index == _integrantes.length)
          //  return SizedBox(height: 50.0);
          return WidgetANimator(
            GestureDetector(
              onTap: _renovadoCheck ? null : (){
                final json = {
                  'nombreCom'  : _renovacionIntegrantes[index].nombreCompleto,
                  'cveCli'     : _renovacionIntegrantes[index].cveCli,
                  'telefonoCel': _renovacionIntegrantes[index].telefono,
                  'importeT'   : _renovacionIntegrantes[index].importe,
                  'diaAtr'     : _renovacionIntegrantes[index].diasAtraso,
                  'capital'    : _renovacionIntegrantes[index].capital,
                  'noCda'      : _renovacionIntegrantes[index].noCda,
                  'tesorero'   : _renovacionIntegrantes[index].tesorero,
                  'presidente' : _renovacionIntegrantes[index].presidente
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

  _solicitarRenovacion() async{
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'Solicitar Renovación',
      icon: Icons.error_outline,
      textContent: '¿Desea solicitar la renovacion del grupo \'${widget.params['nombre']}\'?',
      cancel: 'No, cancelar',
      cntinue: 'Si, solicitar renovación',
      action: _renovar
    ); 
  }

  _renovar() async{
    //validacion numero de integrantes
    if(true){
      userID = await _sharedActions.getUserId();
      Grupo grupo = Grupo(
        cantidadSolicitudes: _renovacionIntegrantes.length,
        //idGrupo: widget.params['contrato'],
        importeGrupo: _capital,
        nombreGrupo: widget.params['nombre'],
        status: 1,
        userID: userID,
        contratoId: widget.params['contrato']
      );
      try{
        DBProvider.db.nuevoGrupo(grupo).then((value)async{ 
          _renovacionIntegrantes.forEach((r) { 
            r.idGrupo = value;
            r.userID = userID; 
          });
          await DBProvider.db.nuevasRenovaciones(_renovacionIntegrantes);
          setState((){_renovadoCheck = true;});
        });
        //CAMPOS FALTANTES DE ASIGNAR beneficio, ticket
      }catch(e){
        _error('No pudo solicitarse la renovación.\n$e');
      }
    }else{
      _error('No pudo solicitarse la renovación.\nDebe tener al menos X integrantes.');
    }
  }

  _error(String error){
    _customSnakBar.showSnackBar(
        error, 
        Duration(milliseconds: 5000), 
        Colors.pink, 
        Icons.error_outline, 
        _scaffoldKey
      );
  }
}