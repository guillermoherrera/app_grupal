import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {  
  const EmptyImage({
    Key key,
    @required this.text
  }) : super(key: key);
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(Constants.emptyImage),
              fit: BoxFit.contain,
            ),
            Text(text.toUpperCase(), style: Constants.mensajeCentral)
          ],
        ),
      ),
    );
  }
}