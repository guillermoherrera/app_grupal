import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          _imagen(_height),
          _formulario(_height, _width)
        ],
      )
    );
  }

  Widget _imagen(double height){
    return Container(
      padding: EdgeInsets.symmetric(vertical: height / 16),
      color: Constants.primaryColor,
      width: double.infinity,
      child: CustomFadeTransition(
        duration: Duration(milliseconds: 3000),
        child: Image(
          image: AssetImage(Constants.logo),
          color: Colors.white,
          height: height / 5,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _formulario(double height, double width){
    List<Widget> content = [
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        child: CustomTextField(
          label: 'Usuario',
          icon: Icons.account_circle,
        ),
      ),
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        offset: 280,
        child: CustomTextField(
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
      ),
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        offset: 420,
        child: CustomRaisedButton(
          label: 'Iniciar Sesión',
        ),
      ),
      SizedBox(height: height / 16,)
    ];

    return Form(
      key: formKey,
      child: Expanded(
        child: Container(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width / 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}