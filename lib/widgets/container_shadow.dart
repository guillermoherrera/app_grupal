import 'package:flutter/material.dart';

class ContainerShadow extends StatelessWidget {
  const ContainerShadow({
    Key key, 
    @required this.child
  }) : super(key: key);
  
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        margin: EdgeInsets.only(top: 0.0, bottom: 6.0, left: 6.0, right: 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 8.0,
            ),
          ]
        ),
        child: child 
        ,
      ),
    );
  }
}