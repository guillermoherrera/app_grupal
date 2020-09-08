import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  const CustomListTile({
    Key key, 
    this.title, 
    this.subtitle, 
    this.leading, 
    this.trailing
  }) : super(key: key);
  
  final Widget title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: title,
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
            trailing == null ? SizedBox(): trailing
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}