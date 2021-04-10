import 'dart:convert';

import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/integrantes_model.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class DetallePedidoPage extends StatefulWidget {
  const DetallePedidoPage({
    Key key, 
    this.params,
    this.integrantes
  }) : super(key: key);

  final Map<String, dynamic> params;
  final List<IntegranteVCAPI> integrantes;
  
  @override
  _DetallePedidoPageState createState() => _DetallePedidoPageState();
}

class _DetallePedidoPageState extends State<DetallePedidoPage> {
  bool _showIcon = true;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BodyContent(
              appBar: _appBar(_height),
              contenido:  _bodyContent()
            )
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

  Widget _bodyContent(){
    List<ListTileModel> listTiles = List();
    final decodeData = json.decode(widget.params['detalle']);
    
    decodeData['detalleExitos'].asMap().forEach((index, mensaje) {

      final nombre = widget.integrantes.firstWhere((item) => item.cveCli == decodeData['cveCliExitos'][index]).nombreCom; 

      final listTile = ListTileModel(
        title: Wrap(
          children: [
            Text(
              '$nombre\nSolicitud de Pedido Exitoso'.toUpperCase(),
              style: Constants.mensajeCentral, 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
        trailing: Icon(Icons.check_circle, color: Constants.primaryColor,),
        subtitle: 'El pedido fue registrado correctamente.',
      );
      listTiles.add(listTile);
    });

    decodeData['detalleError'].asMap().forEach((index, mensaje) {    

      final nombre = widget.integrantes.firstWhere((item) => item.cveCli == decodeData['cveCliError'][index]).nombreCom;

      final listTile = ListTileModel(
        title: Wrap(
          children: [
            Text(
              '$nombre\nFalló la Solicitud de Pedido'.toUpperCase(),
              style: Constants.mensajeCentral, 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
        trailing: Icon(Icons.remove_circle, color: Colors.red,),
        subtitle: 'Error: $mensaje',
      );
      listTiles.add(listTile);
    });
    
    return  ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: decodeData['detalleError'].length + decodeData['detalleExitos'].length,// + 1,
        itemBuilder: (context, index){
          //if(index == _integrantes.length)
          //  return SizedBox(height: 50.0);
          return WidgetANimator(
            Card(
              child: ListTile(
                title: listTiles[index].title,
                subtitle: Text(listTiles[index].subtitle, style: TextStyle(fontSize: 11.0)),
                leading: listTiles[index].leading == null ? null : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    listTiles[index].leading
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    listTiles[index].trailing == null ? SizedBox(): listTiles[index].trailing
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          );
        }
      );
  }
}