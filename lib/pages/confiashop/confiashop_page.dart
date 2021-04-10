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
  String _selectedUrl = '';
  bool _getTicket = false;
  bool cargando = true;

  @override
  void initState() {
    _selectedUrl = 'https://confia-qa.supernova-desarrollo.com/?meta=1&page=mobile&env=dist&tk1=${widget.params['user']}&tk2=&benefit=${widget.params['categoria']}';
    
    _flutterWebviewPlugin.onStateChanged.listen((state) async {
      print('URL --> ${state.url}');
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

    setState(() {});
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
      _flutterWebviewPlugin.close();
      Future.delayed(Duration(milliseconds: 1000));
      Navigator.pop(context);
      widget.setTicket(widget.params['index'], ticket);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{return null;},
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
      cancel: 'No',
      cntinue: 'Si, salir',
      action: ()async{
        Navigator.pop(context);
        await Future.delayed(Duration(milliseconds: 300));
        _flutterWebviewPlugin.close();
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