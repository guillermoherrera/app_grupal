import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:date_format/date_format.dart';


import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/contrato_model.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/providers/asesores_provider.dart';
import 'package:app_grupal/widgets/custom_animated_list.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';

class RenovacionesPage extends StatefulWidget {
  @override
  _RenovacionesPageState createState() => _RenovacionesPageState();
}

class _RenovacionesPageState extends State<RenovacionesPage> with AutomaticKeepAliveClientMixin{
  final _asesoresProvider = AsesoresProvider();
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
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _bodyContent(){
    return cargando ? 
    CustomCenterLoading(texto: 'Cargando renovaciones') : 
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
        title: contrato.nombreGeneral,
        subtitle: 'Contrato: ${contrato.contratoId} | Status: ${contrato.status}\nFecha termino: ${contrato.fechaTermina.substring(3, 5)}/${contrato.fechaTermina.substring(0, 2)}'.toUpperCase(),
        leading: Icon(Icons.group,),
        trailing: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, 'renovacionGrupo');
          },
          child: Icon(Icons.arrow_forward_ios)
        )
      );
      listTiles.add(listTile);
    });

    return Column(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Contratos por Terminar: ${contratos.length}'.toUpperCase(), style: Constants.encabezadoStyle),
              Text('Entre el ${formatDate(startDate, [dd, '/', mm, '/', yyyy])} y el ${formatDate(endDate, [dd, '/', mm, '/', yyyy])}'.toUpperCase(), style: Constants.subtituloStyle)
            ]
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: contratos.length,
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
          )
        )
        //Expanded(child: CustomAnimatedList(lista: listTiles)),
      ],
    );
  }

  Widget _floatingButton(){
    return FloatingActionButton(
      backgroundColor: Constants.primaryColor,
      onPressed: ()async => await _displayPicker(context),
      child: Icon(Icons.date_range),
    );
  }

  Future _displayPicker(BuildContext context)async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: startDate, 
      initialLastDate: endDate, 
      firstDate: DateTime(2015), 
      lastDate: DateTime(DateTime.now().year +1)
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