import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  const CardContent({Key key, this.contenido}) : super(key: key);

  final Widget contenido;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          color: Colors.white,
          child: contenido,
        ),
      ),
    );
  }
}