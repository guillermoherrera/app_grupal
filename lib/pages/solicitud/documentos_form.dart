import 'package:app_grupal/helpers/constants.dart';
import 'package:flutter/material.dart';

class DocumentosForm extends StatelessWidget {
  const DocumentosForm({Key key,
    this.pageController,
    this.backPage
  }) : super(key: key);

  final PageController pageController;
  final VoidCallback backPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, right: 5.0),
      child: SingleChildScrollView(
        child: Column(
          children: _form(),
        ),
      ),
    );
  }

  List<Widget> _form(){
    return [
      Container(
        child: Text('Documentos'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      _buttonBack(),
    ];
  }

  Widget _buttonBack(){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: (){
              if (pageController.hasClients) {
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                );
              }
              backPage();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 10.0, color: Colors.blue),
                Text('Direcccón'.toUpperCase(), style: TextStyle(color: Colors.blue)),
              ],
            )
          ),
        ),
      ],
    );
  }

  Widget flexPadded(Widget child, {bool isRight = true}){
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(top: 10, right: isRight ? 5.0 : 0, left: isRight ? 0 : 5.0 ),
        child: child,
      ),
    );
  }
}

