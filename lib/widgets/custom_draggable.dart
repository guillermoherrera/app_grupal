import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class CustomDraggable extends StatelessWidget {
  const CustomDraggable({
    Key key,
    this.initialChildSize = 0.15,
    this.maxChildSize = 0.45,
    this.minChildSize = 0.05,
    this.closeAction,
    this.iconCloseAction = Icons.close,
    @required this.title,
    @required this.child
  }) : super(key: key);

  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;
  final VoidCallback closeAction;
  final IconData iconCloseAction;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShakeTransition(
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        builder: (context, controller){
          return Container(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  closeAction == null ? SizedBox(height: 10.0,) : Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(child: Icon(iconCloseAction, color: Colors.white), onTap: closeAction)
                      ],
                    ),
                  ),
                  Text(title.toUpperCase(), style: Constants.encabezadoStyle, textAlign: TextAlign.center),
                  SizedBox(height: 20.0),
                  child == null ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)) : child
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )
            ),
          );
        }      
      ),
    );
  }
}