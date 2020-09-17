import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class Fondo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      //color: Constants.primaryColor,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(1.0, 0.0),
          end: FractionalOffset(0.01, 0.0),
          colors: [Color.fromRGBO(118, 189, 33, 1.0), Color.fromRGBO(98, 169, 13, 1.0)]
        )
      ),
    )
    ;
  }
}