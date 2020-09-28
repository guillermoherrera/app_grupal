import 'package:app_grupal/providers/firebase_provider.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/widgets/custom_fade_transition.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/header.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
    this.onSignIn
  }) : super(key: key);

  final VoidCallback onSignIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthFirebase _authFirebase = new AuthFirebase();
  final SharedActions _sharedActions = new SharedActions();
  final CustomSnakBar _customSnakBar = new CustomSnakBar();
  final _firebaseProvider = FirebaseProvider();
  final _formKey = new GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _buttonEnabled = true;

  _loginSubmit() async{
    if(_formKey.currentState.validate()){
      _submitStatus();
      FocusScope.of(context).requestFocus(FocusNode());
      final authResult = await _authFirebase.signIn(_userController.text, _passController.text);
      if(authResult.result){
        _sharedActions.setUserAuth(authResult.email, _passController.text, authResult.uid);
        _firebaseProvider.getCatalogos();
        //widget.onSignIn();
        Navigator.pushReplacementNamed(context, Constants.homePage);
      }else{
        _customSnakBar.showSnackBar(Constants.errorAuth(authResult.mensaje), Duration(milliseconds: 3000), Colors.pink, Icons.error_outline, _scaffoldKey);
        await Future.delayed(Duration(seconds:3));
        _submitStatus();
      }
    }
  }

  _submitStatus(){
    setState(() {
      _buttonEnabled = !_buttonEnabled;
    });
  }
  
  @override
  Widget build(BuildContext context) {

    final bool _isLogout = ModalRoute.of(context).settings.arguments;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
           HeaderCurvo(height: _height),
           Column(
            children: [
              _imagen(_height, _isLogout == null ? false : _isLogout),
              _formulario(_height, _width)
            ],
          )
        ],
      )
    );
  }

  Widget _imagen(double height, bool isLogout){
    return Container(
      padding: EdgeInsets.symmetric(vertical: height / 16),
      color: Colors.transparent,
      width: double.infinity,
      child: CustomFadeTransition(
        tweenBegin: isLogout ? 1.0 : 0.0,
        duration: Duration(milliseconds: 3000),
        child: Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage(Constants.logo),
            color: Colors.white,
            height: height / 4.4,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _formulario(double height, double width){
    List<Widget> content = [
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        child: Container(
          margin: EdgeInsets.only(bottom: height / 16),
          child: CustomTextField(
            label: 'Usuario',
            controller: _userController,
            icon: Icons.account_circle,
            enableUpperCase: true,
          ),
        ),
      ),
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        offset: 280,
        child: Container(
          margin: EdgeInsets.only(bottom: height / 16),
          child: CustomTextField(
            controller: _passController,
            label: 'Password',
            icon: Icons.lock,
            isPassword: true,
          ),
        ),
      ),
      ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(milliseconds: 3000),
        offset: 420,
        child: CustomRaisedButton(
          label: _buttonEnabled ? 'Iniciar Sesión' : 'Verificando porfavor espere ...',
          action: _buttonEnabled ? _loginSubmit : (){}
        ),
      ),
      SizedBox(height: height / 16,)
    ];

    return Form(
      key: _formKey,
      child: Expanded(
        child: Container(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width / 16),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}


