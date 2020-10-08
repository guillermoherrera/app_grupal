import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ConfiashopPage extends StatefulWidget {
  const ConfiashopPage({
    Key key, 
    this.setTicket,
    this.params
  }) : super(key: key);

  final void Function(int, String) setTicket;
  final Map<String, dynamic> params;

  @override
  _ConfiashopPageState createState() => _ConfiashopPageState();
}

class _ConfiashopPageState extends State<ConfiashopPage> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  String _selectedUrl = 'https://confia-dev.supernova-desarrollo.com/?meta=1&page=mobile&env=dist&tk1=D865&tk2=&benefit=1';
  bool _getTicket = false;
  bool cargando = true;

  @override
  void initState() {
    
    _flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        String script =
            'window.addEventListener("message", receiveMessage, false);' +
                'function receiveMessage(event) {Print.postMessage(event.data);}';
        _flutterWebviewPlugin.evalJavascript(script);
      }
    });
    
    _flutterWebviewPlugin.onProgressChanged.listen((event) async{
      print('### ${event.toDouble()}');
      if(event.toDouble()>=1.0 && cargando){
        setState((){cargando=false;});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }

  _setTicket(String ticket)async{
    if(!_getTicket){
      setState(() {_getTicket = true;});
      widget.setTicket(widget.params['index'], ticket);
      Future.delayed(Duration(milliseconds: 1000));
      _flutterWebviewPlugin.close();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){},
      child: Scaffold(
        body: SafeArea(
          child: WebviewScaffold(
            url: _selectedUrl,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Center(
              child: Image(
                image: AssetImage(Constants.confiashop),
                fit: BoxFit.contain,
              ),
            ),
            javascriptChannels: [
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    print('message.message: ${message.message}');
                    _setTicket('${message.message}');
                  }),
            ].toSet(),
          ),
        ),
        bottomNavigationBar: _bottomBar()
      ),
    );
  }

  Widget _bottomBar(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey[300]),
        )
      ),
      child: GestureDetector(
        onTap: ()=>_back(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_back_ios, 
                color: Colors.blue    
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                '${cargando ? 'Cargando confiashop...' : 'Regresar a la app'}'.toUpperCase(), 
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              )
            )
          ],
        ),
      ),
    );
  }

  _back(){
    _flutterWebviewPlugin.hide();
    CustomDialog customDialog = CustomDialog();
    customDialog.showCustomDialog(
      context,
      title: 'ConfiaShop',
      icon: Icons.error_outline,
      textContent: '¿Desea salir de la pagina de confiashop?',
      cancel: 'No, cancelar',
      cntinue: 'Si, salir',
      action: ()async{
        Navigator.pop(context);
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
      },
      cancelAction: ()async{
        Navigator.pop(context);
        //await Future.delayed(Duration(milliseconds: 300));
        _flutterWebviewPlugin.show();    
      }
    );
  }

}