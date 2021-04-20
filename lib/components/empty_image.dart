import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {  
  const EmptyImage({
    Key key,
    @required this.text,
    this.image = 'assets/empty.png'
  }) : super(key: key);
  
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
              Text(text.toUpperCase(), style: Constants.mensajeCentral, textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}