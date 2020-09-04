import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key key,
    @required this.label,
    this.borderColor,
    this.primaryColor,
    this.textColor, 
    this.action
  }) : super(key: key);

  final String label;
  final Color primaryColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: primaryColor != null ? primaryColor : Constants.defaultColor,
      textColor: textColor != null ? textColor : Constants.primaryColor,
      elevation: 0.0,
      child: FittedBox(
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          )
        )
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: borderColor != null ? borderColor : Constants.primaryColor,
          width: 2.0
        )
      ),
      onPressed: () => action(),
    );
  }
}