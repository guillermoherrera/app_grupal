import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  const CustomListTile({
    Key key, 
    this.title, 
    this.subtitle, 
    this.leading, 
    this.trailing
  }) : super(key: key);
  
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Constants.mensajeCentral, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          trailing
        ],
      ),
      isThreeLine: true,
    );
  }
}