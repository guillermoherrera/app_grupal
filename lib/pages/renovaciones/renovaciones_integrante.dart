import 'package:app_grupal/models/ticket_confiashop_model.dart';
import 'package:app_grupal/providers/confiashop_provider.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_draggable.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';

class RenovacionesIntegrentePage extends StatefulWidget {
  const RenovacionesIntegrentePage({
    Key key, 
    this.params,
    this.setMonto,
    this.setTicket,
    this.setRolGrupo
  }) : super(key: key);

  final Map<String, dynamic> params;
  final void Function(int, double) setMonto;
  final void Function(int, String) setTicket;
  final void Function(int, int) setRolGrupo;
  @override
  _RenovacionesIntegrentePageState createState() => _RenovacionesIntegrentePageState();
}

class _RenovacionesIntegrentePageState extends State<RenovacionesIntegrentePage> {
  final _confiashopProvider = ConfiashopProvider();
  final formKey = new GlobalKey<FormState>();
  final importeCapital = TextEditingController();
  final _customRoute = CustomRouteTransition();
  bool _showIcon = true;
  bool _verVenta = false;
  Widget _articulos;
  TicketConfiaShop _ticketConfiaShop;
  

  _getArticulos()async{
    _ticketConfiaShop = await _confiashopProvider.getArticulosByTicket(widget.params['ticket'], 'D865');
    _tableArticulos(_ticketConfiaShop.tIcketDetalle);
    setState((){});
  }

  _tableArticulos(List<TicketDetalle> articulos){
    List<TableRow> tableRows = [];

    tableRows.add(
      TableRow(
        children: [
          Center(child: Text('Artículo\n'.toUpperCase(), style: Constants.subtituloStyle)),
          Center(child: Text('Descripción\n'.toUpperCase(), style: Constants.subtituloStyle)),
          Center(child: Text('Precio total\n'.toUpperCase(), style: Constants.subtituloStyle))
        ]
      )
    );

    articulos.forEach((e){
      tableRows.add(TableRow(children: [Divider(color: Colors.white),Divider(color: Colors.white),Divider(color: Colors.white)]));
      tableRows.add(
        TableRow(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${e.jerarquia01}, ${e.jerarquia02},'.toUpperCase(), style: Constants.subtituloStyle),
                  Text('${e.jerarquia03}, ${e.jerarquia04}'.toUpperCase(), style: Constants.subtituloStyle),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('cantidad: ${e.cantidad}'.toUpperCase(), style: Constants.subtituloStyle),
                Text('talla: ${e.talla}'.toUpperCase(), style: Constants.subtituloStyle),
                Text('color: ${e.color}'.toUpperCase(), style: Constants.subtituloStyle),
                Text('estilo: ${e.estilo}'.toUpperCase(), style: Constants.subtituloStyle),
              ],
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
    });

    Widget table = Table(
      children: tableRows
    );

    _articulos = table;
  } 
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          BodyContent(
            appBar: _appBar(_height),
            contenido: SingleChildScrollView(
              child: Column(
                children: [
                  _encabezado(_height),
                  _capital(_height, context),
                ] 
              ),
            ),
          ),
          _articulosVenta()
        ],
      ),
    );
  }


  Widget _articulosVenta(){
    return !_verVenta ? SizedBox() :
    CustomDraggable(
      closeAction: (){setState((){_verVenta = false;});}, 
      title: 'Artículos',
      child: _articulos,
    );
  }

  Widget _encabezado(double _height){
    return Container(
      padding: EdgeInsets.symmetric(vertical: _height / 32),
      width: double.infinity,
      color: Constants.primaryColor,
      //decoration: BoxDecoration(
      //  gradient: LinearGradient(
      //    begin: FractionalOffset(1.0, 0.0),
      //    end: FractionalOffset(0.01, 0.0),
      //    colors: [Color.fromRGBO(118, 189, 33, 1.0), Color.fromRGBO(98, 169, 13, 1.0)]
      //  )
      //),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(_height / 128),
            child: Icon(
              Icons.person,
              color: Constants.primaryColor,
              size: 100,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle
            ),
          ),
          SizedBox(height: _height / 64),
          Text( widget.params['nombreCom'] , style: Constants.encabezadoStyle),
          widget.params['tesorero'] == 1 ? Text( 'Tesorero'.toUpperCase() , style: Constants.subtituloStyle) : SizedBox(),
          widget.params['presidente']  == 1? Text( 'Presidente'.toUpperCase() , style: Constants.subtituloStyle) : SizedBox()
        ]
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

  Widget _capital(double _height, BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _confiashop(_height, context),
        SizedBox(height: 30.0),
        Divider(),
        _subtitulo('Importe Capital (Renovación)'),
        _monto(),
        SizedBox(height: 30.0),
        Divider(),
        _subtitulo('Informacion último Crédito'),
        _tablaInformacion(),
        SizedBox(height: 30.0),
        Divider(),
        _puestoGrupo(),
      ],
    );
  }

  Widget _confiashop(double _height, BuildContext context){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image(
            image: AssetImage(Constants.confiashop),
            //color: Colors.white,
            height: _height / 10,
            fit: BoxFit.contain,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.params['ticket'] == null ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), 
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    Text(' carrito vacío'.toUpperCase(), style: Constants.encabezadoStyle),
                  ],
                )
              ) : ShakeTransition(
                child: CustomRaisedButton(
                  elevation: 8.0,
                  label: 'ver compra',
                  borderColor: Constants.primaryColor,
                  primaryColor: Colors.blue,
                  textColor: Colors.white,
                  action: (){
                    _articulos = null;
                    _getArticulos();
                    print('ticket => ${widget.params['ticket']}');
                    setState((){_verVenta = true;});
                  },
                ),
              ),
              ShakeTransition(
                child: CustomRaisedButton(
                  elevation: 8.0,
                  label: 'ir a tienda',
                  borderColor: Colors.blue,
                  primaryColor: Colors.blue,
                  textColor: Colors.white,
                  action: ()=>Navigator.push(context, _customRoute.crearRutaSlide(Constants.confiashopPage, {'index': widget.params['index'], 'cveCli': 'D865', 'categoria': 1}, setTicket: _actulizaTicket)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _monto(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffBCEA84),
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), 
            child: Text('\$ ${widget.params['capitalSolicitado']}', style: Constants.mensajeMonto)),
          ShakeTransition(
            child: CustomRaisedButton(
              elevation: 8.0,
              label: 'Actualizar',
              borderColor: Colors.blue,
              primaryColor: Colors.blue,
              textColor: Colors.white,
              action: ()=>_actualizarCapital(),
            ),
          )
        ],
      ),
    );
  }

  Widget _subtitulo(String subtitle){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Text(subtitle.toUpperCase(), style: Constants.mensajeCentral)
    );
  }

  Widget _tablaInformacion(){
    List<TableRow> rowTable = [];
    widget.params.forEach((key, value) {
      rowTable.add(_creaTableRow(key));
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Table(
        children: rowTable,
      ),
    );
  }

  TableRow _creaTableRow(String data){
    return TableRow(
      children: [
        _titulo(data),
        _descripcion(data)
      ],
    );
  }

  Widget _titulo(String data){
    final mostrar = _mostrarDato(data);
    return mostrar == null ? Container() :
      Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: Text(mostrar.toUpperCase(), style: Constants.mensajeCentralNotMedium)
      );
  }

  Widget _descripcion(String data){
    final mostrar = _mostrarDato(data);
    return mostrar == null ? Container() :
      Container(
        padding: EdgeInsets.only(left: 50.0),
        child: Text('${widget.params[data]}', overflow: TextOverflow.ellipsis, style: Constants.mensajeCentralNotMedium)
      );
  }

  String _mostrarDato(String data){
    switch (data) {
      case 'nombreCom':
        return null;
        break;
      case 'cveCli':
        return 'Clave Cliente:';
        break;
      case 'telefonoCel':
        return 'Teléfono:';
        break;
      case 'importeT':
        return 'Importe Total:';
        break;
      case 'diaAtr':
        return 'Dias Atrasados:';
        break;
      case 'capital':
        return 'Capital:';
        break;
      case 'noCda':
        return 'Crédito:';
        break;
      default:
        return null;
    }
  }

  _actualizarCapital() async{
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'Ingresa el monto',
      icon: Icons.monetization_on,
      textContent: '',
      form: _form(),
      cancel: 'Cancelar',
      cntinue: 'Actualizar',
      action: ()=>_actulizaMonto()
    ); 
  }

  Widget _form(){
    return Form(
      key: formKey,
      child: CustomTextField(
        label: 'Importe Capital (Renovación)', 
        controller: importeCapital,
        icon: Icons.attach_money,
        maxLength: 6,
        textType: TextInputType.number,
        check500s: true,
      )
    );
  }

  Widget _puestoGrupo(){
    bool hasRol = widget.params['presidente'] == 1 || widget.params['tesorero'] == 1; 
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          CheckboxListTile(
            title: Text('Presidente'.toUpperCase(), style: Constants.mensajeCentral),
            secondary: Icon(Icons.account_balance),
            controlAffinity: ListTileControlAffinity.platform,
            value: widget.params['presidente'] == 1,
            onChanged: (value)=> hasRol ? null : _confirmChangePuesto(value, 1)
          ),
          CheckboxListTile(
            title: Text('Tesorero'.toUpperCase(), style: Constants.mensajeCentral),
            secondary: Icon(Icons.attach_money),
            controlAffinity: ListTileControlAffinity.platform,
            value: widget.params['tesorero'] == 1,
            onChanged: (value)=> hasRol ? null : _confirmChangePuesto(value, 2)
          )
        ],
      ),
    );
  }

  _confirmChangePuesto(bool val, int opc){
    String rol = opc == 1 ? 'Presidente' : 'Tesorero';
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'Atención',
      icon: Icons.error_outline,
      textContent: '¿Esta seguro de querer hacer a ${widget.params['nombreCom']} $rol de grupo?',
      cancel: 'no, Cancelar',
      cntinue: 'si, asignar',
      action: ()=>_changePuesto(val, opc)
    );
  }

  _changePuesto(bool val, int opc){
    if(val){
      if(opc == 1) widget.params['presidente'] = 1;
      if(opc == 2) widget.params['tesorero'] = 1;
      widget.setRolGrupo(widget.params['index'], opc);
      setState((){});
      Navigator.pop(context);
    }
  }

  _actulizaMonto(){
    if(formKey.currentState.validate()){
      Navigator.pop(context);
      widget.setMonto(widget.params['index'], double.parse(importeCapital.text));
      setState(() {widget.params['capitalSolicitado'] = importeCapital.text;});
    }
  }

  _actulizaTicket(int index, String ticket){
    widget.setTicket(index, ticket);
    setState(() {widget.params['ticket'] = ticket;});
  }
}