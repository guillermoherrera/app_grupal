import 'package:flutter/material.dart';

import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';

class RenovacionesIntegrentePage extends StatefulWidget {
  const RenovacionesIntegrentePage({
    Key key, 
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _RenovacionesIntegrentePageState createState() => _RenovacionesIntegrentePageState();
}

class _RenovacionesIntegrentePageState extends State<RenovacionesIntegrentePage> {
  final _customRoute = CustomRouteTransition();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      //appBar: AppBar(
      //  centerTitle: true,
      //  elevation: 0.0,
      //  iconTheme: IconThemeData(color: Colors.white),
      //  title: Image(
      //    image: AssetImage(Constants.logo),
      //    color: Colors.white,
      //    height: _height / 16,
      //    fit: BoxFit.contain,
      //  ),
      //  leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      //),
      body: BodyContent(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: Image(
            image: AssetImage(Constants.logo),
            color: Colors.white,
            height: _height / 16,
            fit: BoxFit.contain,
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
        ),
        contenido: SingleChildScrollView(
          child: Column(
            children: [
              _encabezado(_height),
              _capital(_height, context)
            ] 
          ),
        ),
      ),
    );
  }

  Widget _encabezado(double _height){
    return Container(
      padding: EdgeInsets.symmetric(vertical: _height / 32),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(1.0, 0.0),
          end: FractionalOffset(0.01, 0.0),
          colors: [Color.fromRGBO(118, 189, 33, 1.0), Color.fromRGBO(98, 169, 13, 1.0)]
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(_height / 128),
            child: Hero(
              tag: widget.params['cveCli'],
              child: Icon(
                Icons.person,
                color: Constants.primaryColor,
                size: 100,
              ),
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
        _subtitulo('ConfiaShop'),
        _confiashop(_height, context),
        SizedBox(height: 30.0),
        _subtitulo('Capital (Renovación)'),
        _monto(),
        SizedBox(height: 30.0),
        _subtitulo('Informacion último Crédito'),
        _tablaInformacion()
      ],
    );
  }

  Widget _confiashop(double _height, BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage(Constants.confiashop),
            //color: Colors.white,
            height: _height / 12,
            fit: BoxFit.contain,
          ),
          ShakeTransition(
            child: CustomRaisedButton(
              label: 'ir a tienda',
              borderColor: Colors.blue,
              primaryColor: Colors.blue,
              textColor: Colors.white,
              action: ()=>Navigator.push(context, _customRoute.crearRutaSlide(Constants.confiashopPage, {})),
            ),
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
            child: Text('\$ ${widget.params['capital']}', style: Constants.mensajeMonto)),
          ShakeTransition(
            child: CustomRaisedButton(
              label: 'Actualizar',
              borderColor: Colors.blue,
              primaryColor: Colors.blue,
              textColor: Colors.white,
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
}