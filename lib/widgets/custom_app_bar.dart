import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';
import 'package:package_info/package_info.dart';

class CustomAppBar extends StatefulWidget {
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
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String versionApp = '';
  
  @override
  void initState() {
    super.initState();
    getVersionInfo();
  }

  getVersionInfo() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionApp = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.0, bottom: 25.0),
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            title: Hero(
              tag: widget.heroTag,
              child: Image(
                image: AssetImage(Constants.logo),
                color: Colors.white,
                height: widget.height / 13,
                fit: BoxFit.contain,
              ),
            ),
            actions: widget.actions,
            leading: widget.leading,
          ),
          Text('v $versionApp'.toUpperCase(), style: Constants.encabezadoStyle,),
        ],
      ),
    );
  }
}