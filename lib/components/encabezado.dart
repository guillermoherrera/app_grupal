import 'package:flutter/material.dart';

class Encabezado extends StatelessWidget {
  const Encabezado({
    Key key,
    @required this.icon,
    @required this.encabezado,
    this.subtitulo = ''
  }) : super(key: key);

  final IconData icon;
  final String encabezado;
  final String subtitulo;


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: _width / 16, vertical: _width / 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white ,size: 40.0),
          SizedBox(width: _width/16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                encabezado.toUpperCase(),
                overflow: TextOverflow.ellipsis, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)
              ),
              Text(
                subtitulo.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white70)
              ),
            ],
          )
        ],
      ),
    );
  }
}