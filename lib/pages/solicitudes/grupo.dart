import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class GrupoPage extends StatefulWidget {
  const GrupoPage({
    Key key,
    this.getLastGrupos,
    this.params,
    this.sincroniza
  }) : super(key: key);

  final Map<String, dynamic> params;
  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;

  @override
  _GrupoPageState createState() => _GrupoPageState();
}

class _GrupoPageState extends State<GrupoPage> {
  final _customRoute = CustomRouteTransition();
  final _customSnakBar = new CustomSnakBar();
  final _sharedActions = SharedActions();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Solicitud> _integrantes = [];
  bool _cargando = true;
  bool _showIcon = true;
  double _capitalTotal = 0;
  int _validaIntegrantesCant = 100;
  String userID;

  @override
  void initState() {
    _buscarIntegrantes();
    super.initState();
  }

  _buscarIntegrantes()async{
    await Future.delayed(Duration(milliseconds: 1000));
    _validaIntegrantesCant = await DBProvider.db.getCatIntegrantesCant();
    _integrantes = await DBProvider.db.getSolicitudesByGrupo(widget.params['idGrupo']);
    getCapitalTotal();
    _cargando = false;
    setState((){});
  }

  getCapitalTotal(){
    _capitalTotal = 0;
    _integrantes.forEach((e){
      _capitalTotal += e.capital;
    });
  }

  _getNewIntegrante(int idSolicitud)async{
    print('id nueva solicitud $idSolicitud');
    await _buscarIntegrantes();
    getCapitalTotal();
    await DBProvider.db.updateGrupoGrupoCantidades(widget.params['idGrupo'], _capitalTotal, _integrantes.length);
    widget.getLastGrupos();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
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
                      Text('${widget.params['nombre']}'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('Integrantes: ${_integrantes.length}'.toUpperCase(), style: _integrantes.length >= _validaIntegrantesCant ? Constants.mensajeCentral2 : Constants.mensajeCentral2error),
                      Text('Total: $_capitalTotal'.toUpperCase(), style: Constants.mensajeCentral3),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.person, color: Constants.primaryColor),
                      Text('${_integrantes.length}'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
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
        bottom: _cargando ? Container() : _buttonEnviar(),
      ),
    );
  }

  Widget _appBar(double _height){
    return CustomAppBar(
      height: _height,
      heroTag: 'logo',
      actions: [
        ShakeTransition(child: 
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0), 
            child: IconButton(
              icon: Icon(Icons.add_circle_outline, size: 40.0),
              onPressed: () => Navigator.push(context, _customRoute.crearRutaSlide(Constants.solicitudPage, {'nombreGrupo': widget.params['nombre'], 'contratoId': widget.params['contrato'], 'idGrupo': widget.params['idGrupo']}, getNewIntegrante: _getNewIntegrante))
            )
          )
        ),
      ],
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
    return _integrantes.length > 0 ? _lista() : _noData();
  }

  Widget _noData(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              Text('\nPresiona '.toUpperCase(), style: Constants.mensajeCentral),
              IconButton(
                icon: Icon(Icons.add_circle_outline, size: 30.0),
                onPressed: () => Navigator.push(context, _customRoute.crearRutaSlide(Constants.solicitudPage, {'nombreGrupo': widget.params['nombre'], 'contratoId': widget.params['contrato'], 'idGrupo': widget.params['idGrupo']}, getNewIntegrante: _getNewIntegrante))
              ),
              Text('\n para agregar integrantes'.toUpperCase(), style: Constants.mensajeCentral),
            ],
          )
        ),
      ],
    );
  }

  Widget _lista(){
    List<ListTileModel> listTiles = List();
    _integrantes.asMap().forEach((index, integrante) {
      final listTile = ListTileModel(
        title: Wrap(
          children: [
            Text(
              '${integrante.nombre} ${integrante.segundoNombre} ${integrante.primerApellido} ${integrante.segundoApellido}', 
              style: Constants.mensajeCentral, 
              overflow: TextOverflow.ellipsis
            ),   
          ],
        ),
        subtitle: 'Importe capital: ${integrante.capital}'.toUpperCase(),
        //trailing: Icon(Icons.arrow_forward_ios, color: Constants.primaryColor),
      );
      listTiles.add(listTile);
    });
    
    return  MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _integrantes.length,// + 1,
        itemBuilder: (context, index){
          //if(index == _integrantes.length)
          //  return SizedBox(height: 50.0);
          return WidgetANimator(
            GestureDetector(
              onTap: (){},
              child: CustomListTile(
                title: listTiles[index].title,
                subtitle: listTiles[index].subtitle,
                trailing: listTiles[index].trailing,
              ),
            )
          );
        }
      ),
    );
  }

  Widget _buttonEnviar(){
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
                color: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
            width: double.infinity,
            height: 50,
            child: CustomRaisedButton(
              action: widget.params['status'] != 0 ? null : () async => _solicitarRenovacion(),
              borderColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
              primaryColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
              textColor: Colors.white,
              label: widget.params['status'] != 0 ? 'Grupo creado' : 'Enviar'
            ),
          ),
        ),
      ],
    );
  }

  _solicitarRenovacion() async{
    if(_integrantes.length >= _validaIntegrantesCant){
      CustomDialog customDialog = CustomDialog();
      customDialog.showCustomDialog(
        context,
        title: 'Guardar y enviar',
        icon: Icons.error_outline,
        textContent: 'Despues de guardar ya no podra modificar la información de este grupo y sus integrantes, dicha información se enviará a mesa de crédito \n\n¿Desea continuar?',
        cancel: 'No, cancelar',
        cntinue: 'Si, guardar y enviar',
        action: _enviarGrupo
      ); 
    }else{
      _error('No pudo solicitarse la creacion y envio del grupo.\nDebe tener al menos $_validaIntegrantesCant integrantes.');
    }
  }

  _enviarGrupo() async{
    Navigator.pop(context);
    userID = await _sharedActions.getUserId();
    try{
      DBProvider.db.updateGrupoStatus(widget.params['idGrupo'], 1).then((value)async{
        widget.params['status'] = 1;
        _success('Grupo guardado.');
        setState((){});
        widget.getLastGrupos();
        _sincronizar();
      });
    }catch(e){
      _error('No pudo crearse el grupo.\n$e');
    }
  }

  _sincronizar()async{
    Future.delayed(Duration(milliseconds: 1000));
    try{
      if(!(await widget.sincroniza()))
        _info('Grupo guardado pero no enviado, sin conexión a internet');
    }catch(e){
      _info('Grupo guardado pero no enviado, sin conexión a internet.');
    }
  }

  _success(String error){
    _customSnakBar.showSnackBarSuccess(
      error, 
      Duration(milliseconds: 2000), 
      Constants.primaryColor, 
      Icons.check_circle_outline, 
      _scaffoldKey
    );
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

  _info(String error){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: 5000),
      Colors.blueAccent,
      Icons.error_outline,
      _scaffoldKey
    );
  }
}