import 'package:flutter/material.dart';

import 'card_content.dart';
import 'fondo.dart';

class BodyContent extends StatelessWidget {
  const BodyContent({
    Key key,
    @required this.contenido,
    this.encabezado,
    this.bottom,
    this.appBar
  }) : super(key: key);
  
  final Widget appBar;
  final Widget contenido;
  final Widget encabezado;
  final Widget bottom;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Fondo(),
        Column(
          children: [
            appBar == null ? Container() : appBar,
            encabezado == null ? Container() : encabezado,
            CardContent(
              contenido: contenido
            ),
            bottom == null ? Container() : bottom
          ],
        )
      ],
    );
  }
}