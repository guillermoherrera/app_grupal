import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/providers/asesores_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/models/contrato_model.dart';

class CarteraPage extends StatefulWidget {
  @override
  _CarteraPageState createState() => _CarteraPageState();
}

class _CarteraPageState extends State<CarteraPage> with AutomaticKeepAliveClientMixin{
  final _asesoresProvider = AsesoresProvider();
  final _customRoute = CustomRouteTransition();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Contrato> contratos = List();
  bool cargando = true;

  _getCartera() async{
    contratos.clear();
    cargando = true;
    await Future.delayed(Duration(milliseconds: 1000));
    if(this.mounted){
      contratos = await _asesoresProvider.consultaCartera();
      cargando = false;
      setState((){});
    }
  }

  @override
  void initState() {
    _getCartera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _bodyContent(), 
    );
  }

  Widget _bodyContent(){
    return cargando ? 
    CustomCenterLoading(texto: 'Cargando grupos') : 
    RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_getCartera(),
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
                      Text('Contratos'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('en cartera activa'.toUpperCase(), style: Constants.mensajeCentral2),
                      //Text('Entre el y el '.toUpperCase(), style: Constants.mensajeCentral3),
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
                physics: BouncingScrollPhysics(),
                itemCount: contratos.length + 1,
                itemBuilder: (context, index){
                  if(index == contratos.length)
                    return SizedBox(height: 50.0);
                  return WidgetANimator(
                    GestureDetector(
                      onTap: (){
                        final json = {'contrato': contratos[index].contratoId, 'nombre': contratos[index].nombreGeneral};
                        Navigator.push(context, _customRoute.crearRutaSlide(Constants.carteraGrupoPage, json));
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

  @override
  bool get wantKeepAlive => true;
}