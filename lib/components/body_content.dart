import 'package:flutter/material.dart';

import 'card_content.dart';
import 'encabezado.dart';
import 'fondo.dart';

class BodyContent extends StatelessWidget {
  const BodyContent({
    Key key,
    @required this.icon,
    @required this.encabezado,
    @required this.subtitulo,
    @required this.contenido
  }) : super(key: key);
  
  final IconData icon;
  final String encabezado;
  final String subtitulo;
  final Widget contenido;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Fondo(),
        Column(
          children: [
            Encabezado(
              icon: icon, 
              encabezado: encabezado,
              subtitulo: subtitulo,
            ),
            CardContent(
              contenido: contenido
            )
          ],
        )
      ],
    );
  }
}