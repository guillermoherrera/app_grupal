import 'package:app_grupal/widgets/custom_fade_transition.dart';
//import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class HomeEmptyPage extends StatefulWidget {
  const HomeEmptyPage({
    Key key, 
    this.scaffoldKey,
    this.sincroniza,
    this.info
  }) : super(key: key);

  final Future<bool> Function() sincroniza;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Map<String, dynamic> info;
  @override
  _HomeEmptyPageState createState() => _HomeEmptyPageState();
}

class _HomeEmptyPageState extends State<HomeEmptyPage> with AutomaticKeepAliveClientMixin{
  //final _customSnakBar = new CustomSnakBar();
  bool sincronizando = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomFadeTransition(
      child: Stack(
        children: [
          ListView(
            children: [
              
              /*Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child:FittedBox(
                  child: Text(
                    'Bienvenido a asesores app'.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
                  )
                )
              ),*/
              Image(
                image: AssetImage(Constants.homeImage),
                fit: BoxFit.contain,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child:Text(
                  ''/*Constants.homeText*/,
                  textAlign: TextAlign.justify,
                  style: Constants.mensajeCentral,
                )
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShakeTransition(
                      axis: Axis.vertical,
                      duration: Duration(milliseconds: 2000),
                      child: RaisedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Icon(sincronizando ? Icons.watch_later : Icons.sync, color: sincronizando ? Colors.grey : Constants.primaryColor,),
                            //Text('Sincronizar'.toUpperCase(), style: TextStyle(fontSize: 6.0, fontWeight: FontWeight.bold, color: sincronizando ? Colors.grey : Constants.primaryColor))
                            Text('Ultimo Inicio de sesión:'.toUpperCase(), style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text('${widget.info['ultimoInicioSesion']}'.toUpperCase(), style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                        padding: EdgeInsets.all(10.0),
                        color: Colors.transparent,//Colors.white,
                        elevation: 0.0,//8.0,
                        shape: CircleBorder(),
                        onPressed: (){}//sincronizando ? (){} : ()=>_sincronizar()
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*_sincronizar()async{
    setState((){sincronizando = !sincronizando;});
    try{
      if(!(await widget.sincroniza()))
        _error('Error desconocido, revisa tu conexión o vuelve a iniciar sesión.');
    }catch(e){
      _error('Error desconocido, revisa tu conexión o vuelve a iniciar sesión.');
    }
    setState((){sincronizando = !sincronizando;});
  }*/

  /*_error(String error){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: 5000),
      Colors.pink,
      Icons.error_outline,
      widget.scaffoldKey
    );
  }*/

  @override
  bool get wantKeepAlive => true;
}