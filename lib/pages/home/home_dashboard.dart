import 'dart:async';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_list_tile.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';
import 'package:app_grupal/models/grupos_model.dart';

class HomeDashboardPage extends StatefulWidget {
  
  const HomeDashboardPage({
    Key key, 
    this.grupos,
    this.scaffoldKey,
    this.getLastGrupos,
    this.sincroniza
  }) : super(key: key);
  
  final List<Grupo> grupos;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;

  @override
  _HomeDashboardPageState createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> with AutomaticKeepAliveClientMixin{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _customRoute = CustomRouteTransition();
  final _customSnakBar = new CustomSnakBar();
  bool sincronizando = false;
  //List<Grupo> __ultimosq15Grupos = List();
  
  @override
  void initState() {
    _sincAutomatica();
    super.initState();
  }

  _sincAutomatica()async{
    final syncTime =  Duration(milliseconds: 600000);
    new Timer.periodic(syncTime, (Timer t)async{
      if(this.mounted){
        _sincronizar();
        print("Sincronización Programada Realizada: "+DateTime.now().toString());
      }else{
        t.cancel();
      }
    });
  }

  _getGrupos()async{
    await Future.delayed(Duration(milliseconds: 1000));
    widget.getLastGrupos();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: _bodyContent(), 
    );
  }

  Widget _bodyContent(){
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () =>_getGrupos(),
      child: _showResult()
    );
  }

  Widget _showResult(){
    return _lista();
  }

  Widget _lista(){
    //final List<Grupo> gruposDash = __ultimosq15Grupos.isEmpty ? widget.grupos : __ultimosq15Grupos;
    List<ListTileModel> listTiles = List();
    widget.grupos.forEach((grupo) {
      final listTile = ListTileModel(
        title: Text(grupo.nombreGrupo, style: Constants.mensajeCentral, overflow: TextOverflow.ellipsis),
        subtitle: 'Capital Total: ${grupo.importeGrupo} | Integrantes: ${grupo.cantidadSolicitudes}\n${grupo.contratoId != null ? "contrato historial: ${grupo.contratoId}" : 'Grupo nuevo'}'.toUpperCase(),
        leading: Icon(Icons.group),
        trailing: Column(
          children: [
            Text('Status'.toUpperCase(), style: Constants.mensajeCentral2),
            Text('${grupo.status == 1 ? 'Pendiente' : 'Enviado'}'.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: grupo.status == 1 ? Colors.yellow[700] : grupo.status == 2 ? Constants.primaryColor : Colors.black),)
          ],
        )//Text('Status\n ${grupo.status == 1 ? 'Pendinte' : 'Enviado'}', textAlign: TextAlign.center,)
      );
      listTiles.add(listTile);
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CustomFadeTransition(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 5.0, top: 20.0),
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
                      Row(
                        children: [
                          Icon(Icons.phone_iphone, size: 12.0, color: Colors.blue),
                          Text('Últimas Solicitudes'.toUpperCase(), style: Constants.mensajeCentral),
                        ],
                      ),
                      Text('capturadas en este dispositivo'.toUpperCase(), style: Constants.mensajeCentral2),  
                    ]
                  ),
                  Column(
                    children: [
                      ShakeTransition(
                        axis: Axis.vertical,
                        duration: Duration(milliseconds: 2000),
                        child: RaisedButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(sincronizando ? Icons.watch_later : Icons.sync, color: sincronizando ? Colors.grey : Constants.primaryColor,),
                              Text('Sincronizar'.toUpperCase(), style: TextStyle(fontSize: 6.0, fontWeight: FontWeight.bold, color: sincronizando ? Colors.grey : Constants.primaryColor))
                            ],
                          ),
                          padding: EdgeInsets.all(10.0),
                          color: Colors.white,
                          elevation: 8.0,
                          shape: CircleBorder(),
                          onPressed: ()=>_sincronizar()
                        ),
                      ),
                    ],
                  )
                  //ClipOval(
                  //  child: GestureDetector(
                  //    onTap: ()=>_sincronizar(),
                  //    child: Column(
                  //      children: [
                  //        Icon(Icons.sync, color: sincronizando ? Colors.grey : Constants.primaryColor,),
                  //        Text('Sincronizar'.toLowerCase(), style: TextStyle(fontSize: 11.0, color: sincronizando ? Colors.grey : Constants.primaryColor))
                  //      ],
                  //    ),
                  //  ),
                  //)
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
                physics: widget.grupos.length > 5 ? BouncingScrollPhysics() : null,
                itemCount: widget.grupos.length + 1,
                itemBuilder: (context, index){
                  if(index == widget.grupos.length)
                    return SizedBox(height: 50.0);
                  return WidgetANimator(
                    GestureDetector(
                      onTap: (){
                        final json = {'nombre': widget.grupos[index].nombreGrupo, 'contrato': widget.grupos[index].contratoId, 'status': widget.grupos[index].status == 1 ? 'Pendiente' : 'Enviado'};
                        Navigator.push(context, _customRoute.crearRutaSlide(Constants.renovacionGrupoPage, json));
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

  _sincronizar()async{
    if(!sincronizando){
      setState((){sincronizando = !sincronizando;});
      _infoSnackbar('Sincronizando, por favor espere');
      try{
        //if(!(await _firebaseProvider.sincronizar(widget.getLastGrupos)))
        if(!(await widget.sincroniza()))
          _error('Error desconocido, revisa tu conexión o vuelve a iniciar sesión.');
      }catch(e){
        _error('Error desconocido, revisa tu conexión o vuelve a iniciar sesión.');
      }
      await Future.delayed(Duration(milliseconds: 1000));
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState((){sincronizando = !sincronizando;});
    }
  }

  _infoSnackbar(String msj){
    _customSnakBar.showSnackBarSuccess(
      msj, 
      Duration(milliseconds: 20000), 
      Colors.blueAccent.withOpacity(0.8), 
      Icons.watch_later, 
      _scaffoldKey
    );
  }

  _error(String error){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: 5000),
      Colors.pink,
      Icons.error_outline,
      widget.scaffoldKey
    );
  }

  @override
  bool get wantKeepAlive => true;
}