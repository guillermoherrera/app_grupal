import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class HomeEmptyPage extends StatefulWidget {
  @override
  _HomeEmptyPageState createState() => _HomeEmptyPageState();
}

class _HomeEmptyPageState extends State<HomeEmptyPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomFadeTransition(
      child: ListView(
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
              style: Constants.mensajeCentral,
            )
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}