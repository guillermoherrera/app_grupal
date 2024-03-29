import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class CustomDialog{
  
  showCustomDialog(BuildContext context, {
    String title = 'Titulo', 
    IconData icon = Icons.help_outline, 
    String textContent = 'Texto contenido.',
    Widget form,
    String cancel = 'Cancelar',
    String cntinue = 'Continuar',
    double offset = 500,
    bool willPop = true,
    @required VoidCallback action,
    VoidCallback cancelAction
  }){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShakeTransition(
          axis: Axis.vertical,
          duration: Duration(milliseconds: 3000),
          offset: offset,
          child: WillPopScope(
            onWillPop: () async => willPop,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Constants.primaryColor, 
                  width: 3.0
                )
              ),
              title: Center(
                child: Text(title.toUpperCase())
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Constants.primaryColor, size: 100.0,),
                    SizedBox(height: 20.0),
                    Text(textContent.toUpperCase(), textAlign: TextAlign.center, style: Constants.mensajeCentral,),
                    form == null ? Container() : form
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(cancel.toUpperCase()),
                  onPressed: ()async{cancelAction == null ? Navigator.pop(context) : cancelAction();}
                ),
                FlatButton(
                  child: Text(cntinue.toUpperCase()),
                  onPressed: ()async{
                    action();
                  }
                )
              ],
            ),
          ),
        );
      }
    );
  }
}