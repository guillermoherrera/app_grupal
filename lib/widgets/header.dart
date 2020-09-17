import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class HeaderCurvo extends StatelessWidget {
  const HeaderCurvo({
    Key key,
    this.height
  }) : super(key: key);
  
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderCurvoPainter(height),
      ),
    );
  }
}

class _HeaderCurvoPainter extends CustomPainter {

  _HeaderCurvoPainter(this.height);
  
  final double height;
  
  @override
  void paint(Canvas canvas, Size size) {
    
    final lapiz = new Paint()..shader = RadialGradient(
    colors: [
      Color.fromRGBO(98, 169, 13, 1.0),
      Color.fromRGBO(118, 189, 33, 1.0),
    ],
  ).createShader(Rect.fromCircle(
    center: Offset(1.0, 1.0),
    radius: 500.0,
  ));

    // Propiedades
    lapiz.color = Constants.primaryColor;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 20;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo( 0, height * 0.30 );
    path.quadraticBezierTo(size.width * 0.5, height * 0.40, size.width, height * 0.30 );
    path.lineTo( size.width, 0 );

  


    canvas.drawPath(path, lapiz );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}