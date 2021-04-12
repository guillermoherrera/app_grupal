import 'dart:convert';

import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:app_grupal/models/result_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:app_grupal/models/ticket_confiashop_model.dart';
import 'package:app_grupal/providers/confiashop_provider.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/providers/vcapi_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_draggable.dart';
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
  final VCAPIProvider _vcapiProvider = new VCAPIProvider();
  final _confiashopProvider = ConfiashopProvider();
  Map<String, dynamic> userInfo;
  List<dynamic> _integrantes = [];
  bool _cargando = true;
  bool _showIcon = true;
  double _capitalTotal = 0;
  double _importeTotal = 0;
  int _validaIntegrantesCant = 100;
  String userID;
  bool _verVenta = false;
  Widget _articulos;
  String _mensajePedido = '';
  String _carritoPropietario;
  TicketConfiaShop _ticketConfiaShop;
  bool _esVenta = false;
  bool _accesoConfiashop = false;

  @override
  void initState() {
    _buscarIntegrantes();
    super.initState();
  }

  _buscarIntegrantes()async{
    userInfo = await _sharedActions.getUserInfo();
    await Future.delayed(Duration(milliseconds: 1000));
    _validaIntegrantesCant = await DBProvider.db.getCatIntegrantesCant();
    _integrantes = widget.params['opcion'] == 'captura' ? await DBProvider.db.getSolicitudesByGrupo(widget.params['idGrupo']) : await _vcapiProvider.consultaIntegrantes(widget.params['idGrupo'], snackBar: _scaffoldKey);
    getCapitalTotal();
    getImporteTotal();
    _cargando = false;
    setState((){});
  }

  getCapitalTotal(){
    _capitalTotal = 0;
    _integrantes.forEach((e){
      if(e.capital != null)_capitalTotal += e.capital;
    });
  }

  getImporteTotal(){
    _importeTotal = 0;
    _integrantes.forEach((e){
      if(e.importeT != null)_importeTotal += e.importeT;
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
    return WillPopScope(
      onWillPop: ()=>_confirmBack(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            BodyContent(
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
                            //Text('Integrantes: ${_integrantes.length}'.toUpperCase(), style: _integrantes.length >= _validaIntegrantesCant ? Constants.mensajeCentral2 : Constants.mensajeCentral2error),
                            widget.params['opcion'] == 'captura' ? Text('Capital: \$$_capitalTotal'.toUpperCase(), style: Constants.mensajeCentral3) : 
                            Table(
                              columnWidths: {
                                0: IntrinsicColumnWidth(),
                                1: IntrinsicColumnWidth(),
                              },
                              children: [
                                TableRow(children:[
                                  Text('Contrato'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' ${widget.params['idGrupo']}'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                                TableRow(children:[
                                  Text('Status'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' ${widget.params['status']}'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                                TableRow(children:[
                                  Text('Atrazos'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' ${widget.params['atrazos']}'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                                TableRow(children:[
                                  Text('Días Atrazo'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' ${widget.params['diasAtrazo']}'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                                TableRow(children:[
                                  Text('Capital total'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' \$$_capitalTotal'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                                TableRow(children:[
                                  Text('Importe total'.toUpperCase(), style: Constants.mensajeCentral3), 
                                  Text(' \$$_importeTotal'.toUpperCase(), style: Constants.mensajeCentral3)
                                ]),
                              ],
                            )
                          ]
                        ),
                        Column(
                          children: [
                            Icon(Icons.person, color: Constants.primaryColor),
                            Text('Integrantes'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
                            Text('${_integrantes.length}'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor)),
                          ],
                        ),
                      ],
                    )
                  ),
                  Divider(color: Colors.black,),
                  Expanded(
                    child: _bodyContent()
                  )
                ] 
              ),
              bottom: _cargando ? Container() : widget.params['opcion'] == 'captura' ? _buttonEnviar() : _buttonComprar(),
            ),
            _articulosVenta()
          ],
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
          widget.params['status'] != 0 ? Container() :Container(
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
              _confirmBack();
              //setState(() {_showIcon = false;});
              //Navigator.pop(context);
            }
          )
        ),
    );
  }

  Widget _articulosVenta(){
    return !_verVenta ? SizedBox() :
    CustomDraggable(
      maxChildSize: 0.62,
      closeAction: (){setState((){_verVenta = false;});}, 
      title: 'Detalle del Pedido\n\nCarrito de\n$_carritoPropietario',
      child: _articulos == null ? _articulos : Column(
        children: [
          _articulos,
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(10.0),
            color: Constants.primaryColor,
            child: Text('\nSTATUS DEL PEDIDO:\n\n$_mensajePedido', textAlign: TextAlign.center, style: Constants.subtituloStyle ,)
          )
        ],
      ),
    );
  }

  _getArticulos(String ticket)async{
    _ticketConfiaShop = await _confiashopProvider.getArticulosByTicket(ticket, userInfo['user']);
    if(_ticketConfiaShop != null){
      _tableArticulos(_ticketConfiaShop);
      setState(() {});
    }else{
      setState((){_verVenta = false;});
      _error('Error al consultar carrito');
    }
  }

  _tableArticulos(TicketConfiaShop ticket){
    List<TableRow> tableRows = [];

    tableRows.add(
      TableRow(
        children: [
          Container(padding: EdgeInsets.all(2.0), child: Center(child: Text('Artículo\n'.toUpperCase(), style: Constants.subtituloStyle))),
          Container(padding: EdgeInsets.all(2.0), child: Center(child: Text('Descripción\n'.toUpperCase(), style: Constants.subtituloStyle))),
          Container(padding: EdgeInsets.all(2.0), child: Center(child: Text('Precio total\n'.toUpperCase(), style: Constants.subtituloStyle)))
        ]
      )
    );
    //tableRows.add(TableRow(children: [Divider(color: Colors.white),Divider(color: Colors.white),Divider(color: Colors.white)]));

    ticket.tIcketDetalle.forEach((e){
      tableRows.add(
        TableRow(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${e.marca}'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('${e.jerarquia01}, ${e.jerarquia02},'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('${e.jerarquia03}, ${e.jerarquia04}'.toUpperCase(), style: Constants.subtituloStyle),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('cantidad: ${e.cantidad}'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('talla: ${e.talla}'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('color: ${e.color}'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('estilo: ${e.estilo}'.toUpperCase(), style: Constants.subtituloStyle),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('\$ ${e.totalPrecioNeto}', style: Constants.subtituloStyle),
              ],
            ),
          ]
        )
      );
      //tableRows.add(TableRow(children: [Divider(color: Colors.white),Divider(color: Colors.white),Divider(color: Colors.white)]));
    });

    tableRows.add(
      TableRow(
        children: [
          Container(),
          Container(padding: EdgeInsets.all(2.0), child: Center(child: Text('\nTotal\n'.toUpperCase(), style: Constants.subtituloStyle))),
          Container(padding: EdgeInsets.all(2.0), child: Center(child: Text('\n\$ ${ticket.totalPrecioNeto}', style: Constants.subtituloStyle)))
        ]
      )
    );

    Widget table = Table(
      border: TableBorder.all(color: Colors.white70),
      children: tableRows
    );

    _articulos = table;
  }

  _confirmBack(){
    if(!_esVenta){
      setState(() {_showIcon = false;});
      Navigator.pop(context);
    }else{
      CustomDialog customDialog = CustomDialog();
      customDialog.showCustomDialog(
        context,
        title: 'Adevertencia',
        icon: Icons.error_outline,
        textContent: '¿Desea Salir de Grupo?.\n\nSi ha terminado con los pedidos de click en salir de lo contrario de en continuar.',//'Si sale ahora del grupo el pedido se cancelará y los carritos de compra hechos se perderan',
        cancel: 'Continuar en el grupo',
        cntinue: 'Salir',
        action: ()async{
          setState(() {_showIcon = false;});
          Navigator.pop(context);
          Navigator.pop(context);
        }
      );
    } 
  }

  _bodyContent(){
    return _cargando ? 
    CustomCenterLoading(texto: 'Cargando información') : _showResult();
  }

  Widget _showResult(){
    return _integrantes.length > 0 ? _lista() : widget.params['opcion'] == 'captura' ?  _noData() : Container();
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
      final jsonDatos = {
        'nombreGrupo': widget.params['nombre'], 
        'contratoId': widget.params['contrato'], 
        'idGrupo': widget.params['idGrupo'],
        'edit': true,
        'idSolicitud': widget.params['opcion'] == 'captura' ? _integrantes[index].idSolicitud : _integrantes[index].cveCli,
        'Integrante': widget.params['opcion'] == 'captura' ? '${_integrantes[index].nombre} ${_integrantes[index].primerApellido}' : _integrantes[index].nombreCom
      };

      final listTile = ListTileModel(
        title: Wrap(
          children: [
            Text(
              widget.params['opcion'] == 'captura' ? '${integrante.nombre} ${integrante.segundoNombre} ${integrante.primerApellido} ${integrante.segundoApellido}' : integrante.nombreCom, 
              style: Constants.mensajeCentral, 
              overflow: TextOverflow.ellipsis
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap:()async{
                  _accesoConfiashop =  await _sharedActions.getAccesoConfiashop();
                  if(integrante.ticket == null){
                    _accesoConfiashop ?
                    Navigator.push(context, _customRoute.crearRutaSlide(Constants.confiashopPage, {'index': widget.params['opcion'] == 'captura' ? _integrantes[index].idSolicitud : index, 'user': userInfo['user'], 'categoria': 1}, setTicket: _actulizaTicket))
                    : _info('Confiashop NO esta DISPONIBLE por el momento');
                  }else{
                    _articulos = null;
                    setState((){
                      _carritoPropietario = integrante.nombreCom;
                      _verVenta = true;
                    });
                    _mensajePedido = integrante.detallePedido;
                    _getArticulos(integrante.ticket);
                  }
                },
                child: Row(
                  children: [
                    Icon(integrante.ticket == null ? Icons.shopping_cart : Icons.local_mall, size: 10.0, color: Colors.blue[900]),
                    Container(
                      child: Text('${integrante.ticket == null ? 'Ir a' : 'Ver pedido'} Confiashop'.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: integrante.ticket == null ? Colors.blue[900] : Constants.primaryColor)),
                      padding: EdgeInsets.only(top: 2.0),      
                    ),
                    Icon(Icons.arrow_forward_ios, size: 10.0, color: Colors.blue[900]),
                  ],
                )
              ),
            ),
          ],
        ),
        subtitle: widget.params['opcion'] == 'captura' ? 'Capital: ${integrante.capital}'.toUpperCase() : 'Importe Total: ${integrante.importeT}\nDías Atrazo: ${integrante.diaAtr}'.toUpperCase(),
        trailing: widget.params['status'] == 0 ? _popMenu(jsonDatos) : _verIntegrante(integrante, index),
        leading: widget.params['opcion'] == 'captura' ? _checks(integrante) : _checksStatic(integrante),
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
            CustomListTile(
              title: listTiles[index].title,
              subtitle: listTiles[index].subtitle,
              trailing: listTiles[index].trailing,
              leading: listTiles[index].leading,
            ),
          );
        }
      ),
    );
  }

  _actulizaTicket(int index, String ticket)async{
    setState(() {
      _integrantes[index].ticket = ticket;
      _integrantes[index].pedido = false;
      _esVenta = true;
    });
    _cargandoHacerPedido();
    await Future.delayed(Duration(milliseconds: 2000));
    await _hacerPedido(index);
    Navigator.pop(context);
    //widget.setTicket(index, ticket);
    //setState(() {widget.params['ticket'] = ticket;});
  }

  _removeTicket(int index){
    setState(() {
      _integrantes[index].ticket = null;
      _integrantes[index].pedido = false;
      _integrantes[index].detallePedido = null;
    });
  }

  Widget _verIntegrante(integrante, int index){
    return IconButton(
      splashColor: Constants.primaryColor,
      icon: Icon(Icons.arrow_forward_ios, color: Constants.primaryColor), 
      onPressed: () => Navigator.push(context, _customRoute.crearRutaSlide(Constants.integrantePage, {
        'cveCli'         : integrante.cveCli,
        'nombreCom'      : integrante.nombreCom,
        'telefonoCel'    : integrante.telefonoCel,
        'importeT'       : integrante.importeT,
        'diaAtr'         : integrante.diaAtr,
        'capital'        : integrante.capital,
        'noCda'          : integrante.noCda,
        'tesorero'       : integrante.tesorero,
        'presidente'     : integrante.presidente,
        'curp'           : integrante.curp,
        'direccion'      : integrante.direccion,
        'fechaNacimiento': integrante.fechaNacimiento,
        'grupo'          : integrante.grupo,
        'ticket'         : integrante.ticket,
        'detallePedido'  : integrante.detallePedido,
        'index'          : index,
      }, getNewIntegrante: _removeTicket))
    );
  }

  Widget _popMenu(json){
    return  PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Constants.primaryColor),
      color: Constants.primaryColor,
      elevation: 20.0,
      itemBuilder: (_) => <PopupMenuItem<int>>[
        new PopupMenuItem<int>(
          child: Row(children: <Widget>[
            Icon(Icons.edit, color: Colors.blue[900]),
            Text(" Ver / Editar".toUpperCase(), style: Constants.subtituloStyle2)],
          ),
          value: 1
        ),
        new PopupMenuItem<int>(
          child: Row(children: <Widget>[
            Icon(Icons.delete_forever, color: Colors.red[900]),
            Text(" Eliminar".toUpperCase(), style: Constants.subtituloStyle2)],
          ),
          value: 2
        ),      
      ],
      onSelected: (value){
        if(value == 1){
          if(widget.params['status'] == 0)Navigator.push(context, _customRoute.crearRutaSlide(Constants.solicitudPage, json, getNewIntegrante: _getNewIntegrante));
        }
        else if(value == 2){
          if(widget.params['status'] == 0){
            CustomDialog customDialog = CustomDialog();
            customDialog.showCustomDialog(
              context,
              title: 'Eliminar Integrante',
              icon: Icons.error_outline,
              textContent: '¿Desea eliminar a ${json['Integrante']} del grupo \'${json['nombreGrupo']}\'?',
              cancel: 'No, cancelar',
              cntinue: 'Si, eliminar',
              action: () => _eliminarIntegrante(json['idSolicitud'])
            );
          }
        }
      }
    );
  }

  _eliminarIntegrante(int idSolicitud){
    print('eliminar');
    Navigator.pop(context);
    DBProvider.db.deleteSolicitud(idSolicitud).then((value)async{
      _success('Integrante Eliminado.');
      _getNewIntegrante(0);  
    });
  }

  Widget _checks(Solicitud integrante){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('P'),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                activeColor: Constants.primaryColor,
                value: integrante.presidente == 1,
                onChanged: (bool val){
                  presidenteChange(val, integrante);
                }
              ),
            ),
          ],
        ),
        SizedBox(width: 5.0,),
        Row(
          children: [
            Text('T'),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                activeColor: Constants.primaryColor,
                value: integrante.tesorero == 1,
                onChanged: (bool val){
                  tesoreroChange(val, integrante);
                }
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _checksStatic(dynamic integrante){
    String rol = '${integrante.tesorero ? 'TESORERO' : integrante.presidente ? 'PRESIDENTE' : 'iNTEGRANTE'}';
    TextStyle estilo = integrante.tesorero ? TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Constants.primaryColor) 
      : integrante.presidente ? TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Constants.primaryColor) 
      : TextStyle(fontSize: 8.0);
    return Text(rol, style: estilo,);
  }

  presidenteChange(bool val, Solicitud integrante){
    if(integrante.tesorero == 1 || widget.params['status'] != 0)
      return false;
    final presidente = _integrantes.where((e) => e.presidente == 1).toList();
    if(presidente.length > 0){
      _integrantes.firstWhere((e) => e.presidente == 1).presidente = 0 ;
    }
    integrante.presidente = val ? 1 : 0;
    setState(() {});
  }

  tesoreroChange(bool val, Solicitud integrante){
    if(integrante.presidente == 1 || widget.params['status'] != 0)
      return false;
    final tesorero = _integrantes.where((e) => e.tesorero == 1).toList();
    if(tesorero.length > 0){
      _integrantes.firstWhere((e) => e.tesorero == 1).tesorero = 0 ;
    }
    integrante.tesorero = val ? 1 : 0;
    setState(() {});
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
            child: _getButton()/*CustomRaisedButton(
              action: widget.params['status'] != 0 ? null : () async => _solicitarRenovacion(),
              borderColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
              primaryColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
              textColor: Colors.white,
              label: widget.params['status'] != 0 ? 'Grupo creado' : 'Enviar'
            ),*/
          ),
        ),
      ],
    );
  }

  Widget _buttonComprar(){
    return Container();
    //int carritos = 0;
    //if(_esVenta)
    //  _integrantes.reduce((value, element) {if((value != null && value.ticket != null) || element.ticket != null) carritos += 1;});
    //return _esVenta ? Stack(
    //  children: [
    //    Container(
    //      color: Colors.white,
    //      width: double.infinity,
    //      height: 50,
    //    ),
    //    ShakeTransition(
    //      child: Container(
    //        decoration: BoxDecoration(
    //            color: Colors.blue,
    //            borderRadius: BorderRadius.only(
    //              topLeft: Radius.circular(30.0),
    //              topRight: Radius.circular(30.0),
    //            )
    //          ),
    //        width: double.infinity,
    //        height: 50,
    //        child: CustomRaisedButton(
    //          action: () async => _confirmHacerPedido(),
    //          borderColor: Colors.blue,
    //          primaryColor: Colors.blue,
    //          textColor: Colors.white,
    //          label: 'Hacer Pedido ($carritos)'
    //        ),
    //      ),
    //    ),
    //  ],
    //) : Container();
  }

  //_confirmHacerPedido(){
  //  CustomDialog customDialog = CustomDialog();
  //  customDialog.showCustomDialog(
  //    context,
  //    title: 'Confirmar',
  //    icon: Icons.shopping_cart,
  //    textContent: 'Se enviarán los carritos generados para hacer el pedido.\n\n ¿Desea Continuar?.',
  //    cancel: 'Cerrar',
  //    cntinue: 'Hacer pedido',
  //    action: ()async{
  //      Navigator.pop(context);
  //      _cargandoHacerPedido();
  //      await Future.delayed(Duration(milliseconds: 2000));
  //      await _hacerPedido();
  //      Navigator.pop(context);
  //    }
  //  );
  //}

  _cargandoHacerPedido(){
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'Haciendo Pedido',
      icon: Icons.watch_later,
      textContent: 'Por favor espere un momento...',
      cancel: '',
      cntinue: '',
      action: (){},
    );
  }

  _hacerPedido(int index)async{
    Result result = await _vcapiProvider.hacerPedido(_integrantes, widget.params['idGrupo'], userInfo['uid']);
    if(result.resultCode == 0){
      
      final decodeData = json.decode(result.resultDesc);
      print(decodeData);
      SnackBarAction action = SnackBarAction(
        textColor: Colors.white,
        label: 'VER DETALLE', 
        onPressed: (){
          _articulos = null;
          setState((){
            _carritoPropietario = _integrantes[index].nombreCom;
            _verVenta = true;
          });
          _mensajePedido = _integrantes[index].detallePedido;
          _getArticulos(_integrantes[index].ticket);
        }//()=>Navigator.push(context, _customRoute.crearRutaSlide(Constants.pedidoPage, {'detalle': result.resultDesc}, listaDinamica: _integrantes)),
      );
      if(decodeData['error'] == 0){
        //setState(() {_esVenta = false;});
        setState((){
          _integrantes[index].pedido = true;
          _integrantes[index].detallePedido = 'Pedido Realizado correctamente';
        });
        _success('Pedido realizado con éxito.');
        _info('Vea el detalle de la solicitud.', action: action);
      }else if(decodeData['exito'] == 0){
        _error('No pudo realizarce el pedido.', action: action);
        setState((){
          _integrantes[index].pedido = true;
          _integrantes[index].detallePedido = decodeData['detalleError'][0];
        });
      }else if(decodeData['exito'] > 0 && decodeData['error'] > 0){
        _info('Atención. Vea el detalle.', action: action);
      }
    }else{
      _error(result.resultDesc);
    }
  }

  Widget _getButton(){
    return CustomRaisedButton(
        action: widget.params['status'] != 0 ? (){} : () async => _solicitarRenovacion(),
        borderColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
        primaryColor: widget.params['status'] != 0 ? Constants.primaryColor : Colors.blue,
        textColor: Colors.white,
        label: widget.params['status'] != 0 ? 'Grupo creado' : 'Enviar'
      );
  }

  _solicitarRenovacion() async{
    if(_integrantes.length >= _validaIntegrantesCant){
      final presidente = _integrantes.where((e) => e.presidente == 1).toList();
      final tesorero = _integrantes.where((e) => e.tesorero == 1).toList();
      if(presidente.length > 0){
        if(tesorero.length > 0){
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
          _error('El grupo debe tener al menos un integrante como tesorero. (T)');
        }
      }else{
        _error('El grupo debe tener al menos un integrante como presidente. (P)');
      } 
    }else{
      _error('No pudo solicitarse la creacion y envio del grupo.\nDebe tener al menos $_validaIntegrantesCant integrantes.');
    }
  }

  _enviarGrupo() async{
    Navigator.pop(context);
    userID = await _sharedActions.getUserId();
    final presidente = _integrantes.where((e) => e.presidente == 1).toList()[0];
    final tesorero = _integrantes.where((e) => e.tesorero== 1).toList()[0];
    try{
      DBProvider.db.updateSolicitudPresidente(presidente.idSolicitud).then((value) => {
        DBProvider.db.updateSolicitudTesorero(tesorero.idSolicitud).then((value) => {
          DBProvider.db.updateGrupoStatus(widget.params['idGrupo'], 1).then((value)async{
            widget.params['status'] = 1;
            _success('Grupo guardado.');
            setState((){});
            widget.getLastGrupos();
            _sincronizar();
          })
        })
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

  _success(String error, {int milliseconds = 2000}){
    _customSnakBar.showSnackBarSuccess(
      error, 
      Duration(milliseconds: milliseconds), 
      Constants.primaryColor, 
      Icons.check_circle_outline, 
      _scaffoldKey
    );
  }

  _error(String error, {int milliseconds = 5000, SnackBarAction action}){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: milliseconds),
      Colors.pink,
      Icons.error_outline,
      _scaffoldKey,
      action: action
    );
  }

  _info(String error, {int milliseconds = 5000, SnackBarAction action}){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: milliseconds),
      Colors.blueAccent,
      Icons.error_outline,
      _scaffoldKey,
      action: action
    );
  }
}