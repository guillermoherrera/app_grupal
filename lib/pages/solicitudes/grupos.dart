import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
//import 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/providers/vcapi_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class GruposPage extends StatefulWidget {
  const GruposPage({
    Key key, 
    this.params,
    this.getLastGrupos,
    this.sincroniza
  }) : super(key: key);

  final Map<String, dynamic> params;
  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;

  @override
  _GruposPageState createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _customRoute = CustomRouteTransition();
  final VCAPIProvider _vcapiProvider = new VCAPIProvider();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> _grupos = List();
  bool _cargando = true;
  bool _showIcon = false;

  @override
  void initState() {
    _buscarGrupos();
    super.initState();
  }

  _buscarGrupos()async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {_showIcon = true;});
    _grupos = widget.params['opcion'] == 'captura'? await DBProvider.db.getGruposCreados() : await _vcapiProvider.consultaGrupos(snackBar: _scaffoldKey);
    _cargando = false;
    if(this.mounted) setState((){});
  }

  _recargarGrupos()async{
    widget.getLastGrupos();
    await _buscarGrupos();
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
                      Text('${widget.params['opcion'] == 'captura'? 'Grupos en captura' : 'Mis grupos'}'.toUpperCase(), style: Constants.mensajeCentral2bold),
                      Text(''.toUpperCase(), style: Constants.mensajeCentral2),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.group, color: Constants.primaryColor),
                      Text('${_grupos.length}'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
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
    CustomCenterLoading(texto: 'Cargando información') :
    RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_buscarGrupos(),
      child: _showResult()
    );
  }

  Widget _showResult(){
    return _grupos.length > 0 ? _lista() : _noData();
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
      child: Stack(children: [
        CustomFadeTransition(child: EmptyImage(text: 'No hay grupos para mostrar'), duration: Duration(milliseconds: 2000),),
        ListView()
      ]),
    );
  }

  Widget _lista(){
    List<ListTileModel> listTiles = List();
    _grupos.asMap().forEach((index, grupo) {
      final listTile = ListTileModel(
        title: Wrap(
          children: [
            Text(
              '${grupo.nombreGrupo} ', 
              style: Constants.mensajeCentral, 
              overflow: TextOverflow.ellipsis
            ),   
          ],
        ),
        subtitle: 'Importe total: \$${widget.params['opcion'] == 'captura'? grupo.importeGrupo : grupo.importe}\nIntegrantes: ${widget.params['opcion'] == 'captura'? grupo.cantidadSolicitudes : grupo.cantidadIntegrantes}'.toUpperCase(),
        trailing: Icon(Icons.arrow_forward_ios, color: Constants.primaryColor),
      );
      listTiles.add(listTile);
    });
    
    return  MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        //physics: BouncingScrollPhysics(),
        itemCount: _grupos.length,// + 1,
        itemBuilder: (context, index){
          //if(index == _integrantes.length)
          //  return SizedBox(height: 50.0);
          return WidgetANimator(
            GestureDetector(
              onTap: (){
                Navigator.push(context, _customRoute.crearRutaSlide(
                  Constants.grupoPage,
                  {
                    'nombre'    : _grupos[index].nombreGrupo, 
                    'status'    : _grupos[index].status,
                    'idGrupo'   : widget.params['opcion'] == 'captura' ? _grupos[index].idGrupo : _grupos[index].contratoId,
                    'atrazos'   : widget.params['opcion'] == 'captura' ? 0 : _grupos[index].atrazos,
                    'diasAtrazo': widget.params['opcion'] == 'captura' ? 0 :_grupos[index].diasAtrazo,
                    'opcion'    : widget.params['opcion'],
                  }, 
                  getLastGrupos: _recargarGrupos, 
                  sincroniza: widget.sincroniza
                ));
              },
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
}