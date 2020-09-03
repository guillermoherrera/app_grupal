import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class CustomCenterLoading extends StatelessWidget {
  const CustomCenterLoading({
    Key key,
    @required this.texto
  }) : super(key: key);

  final texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.primaryColor)
            ),
            SizedBox(height: 20.0),
            Text(
              texto.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: Constants.mensajeCentral,
            )
          ],
        ),
      ),
    );
  }
}