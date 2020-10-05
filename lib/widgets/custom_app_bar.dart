import 'dart:math';

import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key, 
    @required this.height,
    this.actions,
    this.leading,
    this.heroTag = ''
  }) : super(key: key);

  final double height;
  final Widget leading;
  final List<Widget> actions;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.0, bottom: 25.0),
      child: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Hero(
          tag: heroTag,
          child: Image(
            image: AssetImage(Constants.logo),
            color: Colors.white,
            height: height / 13,
            fit: BoxFit.contain,
          ),
        ),
        actions: actions,
        leading: leading,
      ),
    );
  }
}