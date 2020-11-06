import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class GrupoPage extends StatefulWidget {
  const GrupoPage({
    Key key, 
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;
  @override
  _GrupoPageState createState() => _GrupoPageState();
}

class _GrupoPageState extends State<GrupoPage> {
  final _customRoute = CustomRouteTransition();
  List<Solicitud> _integrantes = [];
  bool _cargando = true;
  bool _showIcon = true;

  @override
  void initState() {
    _buscarIntegrantes();
    super.initState();
  }

  _buscarIntegrantes()async{
    await Future.delayed(Duration(milliseconds: 1000));
    _integrantes = await DBProvider.db.getSolicitudesByGrupo(widget.params['idGrupo']);
    _cargando = false;
    setState((){});
  }

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
                      Text('${widget.params['nombre']}'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('Integrantes 0 | Capital 0.0'.toUpperCase(), style: Constants.mensajeCentral2),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.person, color: Constants.primaryColor),
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
      actions: [
        ShakeTransition(child: 
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0), 
            child: IconButton(
              icon: Icon(Icons.add_circle_outline, size: 40.0),
              onPressed: () => Navigator.push(context, _customRoute.crearRutaSlide(Constants.solicitudPage, {'nombreGrupo': widget.params['nombre'], 'contratoId': widget.params['contrato'], 'idGrupo': widget.params['idGrupo']}))
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
                onPressed: () => Navigator.push(context, _customRoute.crearRutaSlide(Constants.solicitudPage, {'nombreGrupo': widget.params['nombre'], 'contratoId': widget.params['contrato'], 'idGrupo': widget.params['idGrupo']}))
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
}