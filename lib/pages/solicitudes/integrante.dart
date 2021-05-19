import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class IntegrantePage extends StatefulWidget {
  const IntegrantePage({
    Key key, 
    this.params,
    this.removeTicket
  }) : super(key: key);
  
  final Map<String, dynamic> params;
  final void Function(int) removeTicket;

  @override
  _IntegrantePageState createState() => _IntegrantePageState();
}

class _IntegrantePageState extends State<IntegrantePage> {
  bool _showIcon = false;

  @override
  void initState() {
    _initPage();
    super.initState();
  }

  _initPage()async{
     await Future.delayed(Duration(milliseconds: 1000));
    setState(() {_showIcon = true;});
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
        ],
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
          widget.params['tesorero'] ? Text( 'Tesorero'.toUpperCase() , style: Constants.subtituloStyle) : SizedBox(),
          widget.params['presidente'] ? Text( 'Presidente'.toUpperCase() , style: Constants.subtituloStyle) : SizedBox()
        ]
      )
    );
  }

  Widget _capital(double _height, BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tablaInformacion(),
        Center(child: _eliminarTicket()),
      ],
    );
  }

  Widget _eliminarTicket(){
    if(widget.params['detallePedido'] == null || widget.params['detallePedido'].contains('correctamente'))
      return Container();

    return ShakeTransition(
      child: CustomRaisedButton(
        label: 'Eliminar Pedido',
        action: ()=>_confirm()
      ),
    );
  }

  _confirm(){
    
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'Atención',
      icon: Icons.error_outline,
      textContent: '¿Desea eliminar el pedido de este cliente?',//'Si sale ahora del grupo el pedido se cancelará y los carritos de compra hechos se perderan',
      cancel: 'No',
      cntinue: 'Si, elimiar',
      action: (){
        setState(() {
          widget.params['detallePedido'] = null;
        });
        widget.removeTicket(widget.params['index']);
        Navigator.pop(context);
      }
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
        child: Text(mostrar.toUpperCase(), style: Constants.mensajeCentral2bold)
      );
  }

  Widget _descripcion(String data){
    final mostrar = _mostrarDato(data);
    return mostrar == null ? Container() :
      Container(
        padding: EdgeInsets.only(left: 50.0),
        child: Text('${widget.params[data]}', style: Constants.mensajeCentral2)
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
      case 'direccion':
        return 'direccion:';
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
        return 'noCda:';
        break;
      default:
        return null;
    }
  }
}