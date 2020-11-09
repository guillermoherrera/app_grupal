import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:date_format/date_format.dart';


import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/contrato_model.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/providers/asesores_provider.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';

class RenovacionesPage extends StatefulWidget {

  const RenovacionesPage({
    Key key, 
    this.getLastGrupos,
    this.sincroniza  
  }) : super(key: key);
  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;

  @override
  _RenovacionesPageState createState() => _RenovacionesPageState();
}

class _RenovacionesPageState extends State<RenovacionesPage> with AutomaticKeepAliveClientMixin{
  final _asesoresProvider = AsesoresProvider();
  final _customRoute = CustomRouteTransition();
  List<Contrato> contratos = List();
  bool cargando = true;
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));

  @override
  void initState() {
    _getRenovaciones();
    super.initState();
  }

  _getRenovaciones() async{
    contratos.clear();
    cargando = true;
    await Future.delayed(Duration(milliseconds: 1000));
    String paramDateInicio = formatDate(startDate, [mm, '/', dd, '/', yyyy]);
    String paramDateFin = formatDate(endDate, [mm, '/', dd, '/', yyyy]);
    contratos = await _asesoresProvider.consultaRenovaciones(paramDateInicio, paramDateFin);
    cargando = false;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _bodyContent(), 
      floatingActionButton: cargando ? null : 
      ShakeTransition(axis: Axis.vertical, duration: Duration(milliseconds: 2000) ,child: _floatingButton()),
    );
  }

  Widget _bodyContent(){
    return cargando ? 
    CustomCenterLoading(texto: 'Cargando grupos') : 
    RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_getRenovaciones(),
      child: _showResult()
    );
  }

  Widget _showResult(){
    return contratos.length > 0 ? _lista() : _noData();
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
    contratos.forEach((contrato) {
      final listTile = ListTileModel(
        title: Text(contrato.nombreGeneral, style: Constants.mensajeCentral, overflow: TextOverflow.ellipsis),
        subtitle: 'Contrato: ${contrato.contratoId} | Status: ${contrato.status}\nFecha termino: ${contrato.fechaTermina.substring(3, 5)}/${contrato.fechaTermina.substring(0, 2)}'.toUpperCase(),
        leading: Icon(Icons.group,),
        trailing: Icon(Icons.arrow_forward_ios, color: Constants.primaryColor,)
      );
      listTiles.add(listTile);
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CustomFadeTransition(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contratos por Terminar'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('Consulta realizada'.toUpperCase(), style: Constants.mensajeCentral2),
                      Text('Entre el ${formatDate(startDate, [dd, '/', mm, '/', yyyy])} y el ${formatDate(endDate, [dd, '/', mm, '/', yyyy])}'.toUpperCase(), style: Constants.mensajeCentral3),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.group, color: Constants.primaryColor,),
                      Text('${contratos.length}', style: TextStyle(fontSize: 11.0, color: Constants.primaryColor))
                    ],
                  )
                ],
              )
            ),
          ),
          Divider(),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                //physics: BouncingScrollPhysics(),
                itemCount: contratos.length + 1,
                itemBuilder: (context, index){
                  if(index == contratos.length)
                    return SizedBox(height: 50.0);
                  return WidgetANimator(
                    GestureDetector(
                      onTap: (){
                        final json = {'nombre': contratos[index].nombreGeneral, 'contrato': contratos[index].contratoId, 'status': contratos[index].status};
                        Navigator.push(context, _customRoute.crearRutaSlide(Constants.renovacionGrupoPage, json, getLastGrupos: widget.getLastGrupos, sincroniza: widget.sincroniza));
                      },
                      child: CustomListTile(
                        title: listTiles[index].title,
                        subtitle: listTiles[index].subtitle,
                        //leading: listTiles[index].leading,
                        trailing: listTiles[index].trailing,
                      ),
                    )
                  );
                }
              ),
            )
          )
          //Expanded(child: CustomAnimatedList(lista: listTiles)),
        ],
      ),
    );
  }

  Widget _floatingButton(){
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: ()async => await _displayPicker(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.date_range, color: Constants.primaryColor,),
          Text('Consulta'.toUpperCase(), style: TextStyle(fontSize: 6.0, fontWeight: FontWeight.bold, color: Constants.primaryColor))
        ],
      ),
    );
  }

  Future _displayPicker(BuildContext context)async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: startDate, 
      initialLastDate: endDate, 
      firstDate: DateTime(2015), 
      lastDate: DateTime(DateTime.now().year +2)
    );
    if(picked != null && picked.length == 2){
      _getRenovaciones();
      setState(() {
        startDate = picked[0];
        endDate = picked[1];
      });
      _getRenovaciones();
    }
  }

  @override
  bool get wantKeepAlive => true;
}