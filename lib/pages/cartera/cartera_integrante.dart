import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/empty_image.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_center_loading.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class CarteraIntegrantePage extends StatefulWidget {
  const CarteraIntegrantePage({
    Key key,
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _CarteraIntegrantePageState createState() => _CarteraIntegrantePageState();
}

class _CarteraIntegrantePageState extends State<CarteraIntegrantePage> {
  bool _cargando = true;
  bool _showIcon = true;
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BodyContent(
            appBar: _appBar(_height),
            contenido: _bodyContent(),
          )
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

  _bodyContent(){
    return !_cargando ? 
    CustomCenterLoading(texto: 'Cargando información') : _showResult();
  }

  Widget _showResult(){
    return true ? _infoView() : _noData();
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
              Text('Cartera'.toUpperCase(), overflow: TextOverflow.ellipsis, style: Constants.mensajeMonto3),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Text('Fecha Termino         : '.toUpperCase(), style: Constants.mensajeCentral2bold),
                  Text('Fecha Ultimo Pago : '.toUpperCase(), style: Constants.mensajeCentral2bold),
                ]
              )
            ],
          ),
          SizedBox(height: 20.0),
          Table(
            children: [
              _tableRow("Nombre ", '${widget.params['nombreCom']}'),
              _tableRow("Cliente ", '${widget.params['cveCli']}'),
              _tableRow("Importe ", '\$'),
              _tableRow("Saldo Actual ", '\$'),
              _tableRow("Saldo Atrasado ", '\$'),
              _tableRow("Días Atraso ", '0'),
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
        Align(child:FittedBox(child: Text(data, style: Constants.mensajeMonto3)), alignment: Alignment.centerRight),
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
            Text('', style: Constants.mensajeMonto3),
            Text("No. corrida".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('', style: Constants.mensajeMonto3),
            Text("Folio".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('', style: Constants.mensajeMonto3),
            Text("Pagos".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
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
            FittedBox(child: Text('\$', style: Constants.mensajeMonto3)),
            Text("Capital".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('\$', style: Constants.mensajeMonto3),
            Text("Intereses".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
            SizedBox(height: 10.0),
            Text('${widget.params['telefonoCel']}', style: Constants.mensajeMonto3),
            Text("Teléfono".toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 15)),
          ])
        ),
      )
    );
  }
}