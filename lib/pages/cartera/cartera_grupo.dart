import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/contrato_model.dart';
import 'package:app_grupal/providers/asesores_provider.dart';
import 'package:app_grupal/widgets/animator.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_draggable.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class CarteraGrupoPage extends StatefulWidget {
  const CarteraGrupoPage({
    Key key, 
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _CarteraGrupoPageState createState() => _CarteraGrupoPageState();
}

class _CarteraGrupoPageState extends State<CarteraGrupoPage> {
  final _asesoresProvider = AsesoresProvider();
  final _customRoute = CustomRouteTransition();
  ContratoDetalle _contratoDetalle = ContratoDetalle();
  bool _cargando = true;
  bool _showIcon = true;

  @override
  void initState() {
    _getDetalle();
    super.initState();
  }

  _getDetalle()async{
    await Future.delayed(Duration(milliseconds: 1000));
    _contratoDetalle = await _asesoresProvider.consultaContratoDetalle(widget.params['contrato']);
    setState(() {_cargando = false;});
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          BodyContent(
            appBar: _appBar(_height),
            contenido: _bodyContent(),
          ),
          _integrantes(_height)
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

  Widget _integrantes(double _height){
    return CustomDraggable(
      initialChildSize: 0.15,
      maxChildSize: 0.7,
      title: 'Integrantes',
      child: _contratoDetalle.integrantes != null ? _lista(_height) : null ,
    );
  }

  _bodyContent(){
    return _cargando ? 
    CustomCenterLoading(texto: 'Cargando información') : _showResult();
  }

  Widget _showResult(){
    return _contratoDetalle.integrantes != null ? _infoView() : _noData();
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
      child: Stack(children: [
        CustomFadeTransition(child: EmptyImage(text: 'Sin resultados'), duration: Duration(milliseconds: 2000),),
        ListView()
      ]),
    );
  }

  Widget _infoView(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 250.0,
                child: Text('${widget.params['nombre']}'.toUpperCase(), overflow: TextOverflow.ellipsis, style: Constants.mensajeMonto3)
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Text('Fecha Inicio : ${_contratoDetalle.contrato.fechaInicio.substring(0, 10)}'.toUpperCase(), style: Constants.mensajeCentral2bold),
                  Text('Fecha Fin    : ${_contratoDetalle.contrato.fechaTermina.substring(0, 10)}'.toUpperCase(), style: Constants.mensajeCentral2bold)
                ]
              )
            ],
          ),
          SizedBox(height: 20.0),
          Table(
            children: [
              _tableRow('Contrato'      , '${widget.params['contrato']}'),
              _tableRow('Importe Total' , '\$${_contratoDetalle.contrato.importe.toStringAsFixed(2)}'),
              _tableRow('Saldo Actual'  , '\$${_contratoDetalle.contrato.saldoActual.toStringAsFixed(2)}'),
              _tableRow('Saldo Atrasado', '\$${_contratoDetalle.contrato.saldoAtrazado.toStringAsFixed(2)}'),
              _tableRow('Días Atraso'   , '${_contratoDetalle.contrato.diasAtrazo}'),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              _card1(),
              _card2()
            ]
          )
        ],
      ),
    );
  }

  TableRow _tableRow(String title, String data){
    return TableRow(
      children: [
        Container(padding: EdgeInsets.only(bottom: 10.0),child: Text(title.toUpperCase(), style: Constants.mensajeMonto2)),
        Align(child:Text(data, style: Constants.mensajeMonto3), alignment: Alignment.centerRight),
      ]
    );
  }

  Widget _card1(){
    return Expanded(
      child: Card(
        color: Constants.defaultColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))//.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
        ),
        child:  Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: <Widget>[
            Text('\$${_contratoDetalle.contrato.pagoXPlazo.toStringAsFixed(2)}', style: Constants.mensajeMonto3),
            Text("Pago plazo".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('${_contratoDetalle.contrato.ultimoPlazoPag}', style: Constants.mensajeMonto3),
            Text("Plazo actual".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('${_contratoDetalle.contrato.plazos}', style: Constants.mensajeMonto3),
            Text("Plazos".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
          ])
        ),
      )
    );
  }

  Widget _card2(){
    return Expanded(
      child: Card(
        color: Constants.defaultColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))//.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
        ),
        child:  Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: <Widget>[
            FittedBox(child: Text('\$${_contratoDetalle.contrato.capital.toStringAsFixed(2)}', style: Constants.mensajeMonto3)),
            Text("Capital".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('\$${_contratoDetalle.contrato.interes.toStringAsFixed(2)}', style: Constants.mensajeMonto3),
            Text("Intereses".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('${_contratoDetalle.contrato.integrantesCant}', style: Constants.mensajeMonto3),
            Text("Integrantes".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
          ])
        ),
      )
    );
  }

  Widget _lista(double _height){
    return Container(
      height: _height / 1.6,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _contratoDetalle.integrantes.length,// + 1,
          itemBuilder: (context, index){
            //if(index == _integrantes.length)
            //  return SizedBox(height: 50.0);
            return WidgetANimator(
              GestureDetector(
                onTap: (){
                  final json = {
                    'index'       : index,
                    'nombreCom'   : _contratoDetalle.integrantes[index].nombreCom,
                    'cveCli'      : _contratoDetalle.integrantes[index].cveCli,
                    'telefonoCel' : _contratoDetalle.integrantes[index].telefonoCel,
                    'importeT'    : _contratoDetalle.integrantes[index].importeT,
                    'diaAtr'      : _contratoDetalle.integrantes[index].diaAtr,
                    'capital'     : _contratoDetalle.integrantes[index].capital,
                    'noCda'       : _contratoDetalle.integrantes[index].noCda,
                    'tesorero'    : _contratoDetalle.integrantes[index].tesorero,
                    'presidente'  : _contratoDetalle.integrantes[index].presidente,
                  };
                  print(json);
                  Navigator.push(context, _customRoute.crearRutaSlide(Constants.carteraIntegrantePage, json));
                },
                child: ListTile(
                  title: Text('${index+1}     ${_contratoDetalle.integrantes[index].nombreCom}', style: Constants.subtituloStyle),
                  subtitle: Text('        ${_contratoDetalle.integrantes[index].presidente ? 'Presidente' : _contratoDetalle.integrantes[index].tesorero ? 'Tesorero' : ''}'.toUpperCase(), style: Constants.subtituloStyle,),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
                ),
              )
            );
          }
        ),
      ),
    );
  }
}