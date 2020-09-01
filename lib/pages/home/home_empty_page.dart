import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class HomeEmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image(
          image: AssetImage(Constants.homeImage),
          fit: BoxFit.contain,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child:Text(
            'Bienvenido a Asesores App.',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)
          )
        ),
        Container(
          padding: EdgeInsets.all(20),
          child:Text(
            Constants.homeText,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15),
          )
        )
      ],
    );
  }
}