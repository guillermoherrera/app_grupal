import 'package:app_grupal/classes/auth_firebase.dart';
import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/providers/firebase_provider.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _authFirebase = new AuthFirebase();
  final _firebaseProvider = new FirebaseProvider();
  final _sharedActions = new SharedActions();
  final _customSnakBar = new CustomSnakBar();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmNewPassController = TextEditingController();
  bool _enviando = false;
  
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: BodyContent(
        appBar: _appBar(_height),
        contenido: _formulario(), 
        bottom: _buttons(),
      ),
    );
  }

  Widget _appBar(double _height){
    return CustomAppBar(
      height: _height,
      heroTag: '',
      leading: ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios, size: 40.0,), onPressed: ()=>Navigator.pop(context))),
    );
  }

  Widget _formulario(){
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: Constants.primaryColor,
                  child: Hero(tag: 'contraseña', child: Icon(Icons.lock, color: Colors.white, size: 40.0,))
                ),
              ),
              Container(
                child: Text('\nLa opción de actualizar contraseña estará próximamente disponible.', style: Constants.mensajeCentral, textAlign: TextAlign.center),
                width: double.infinity,
              )
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contraseña'.toUpperCase(), style: Constants.mensajeCentral),
                      Text('Actualiza la contraseña periodicamente\npara una mayor seguridad de tus datos.'.toUpperCase(), style: Constants.mensajeCentral2),
                      //Text('Paso ${_currentPage+1}/3'.toUpperCase(), style: Constants.mensajeCentral3),
                    ]
                  ),
                  Column(
                    children: [
                      Icon(Icons.person, color: Constants.primaryColor,),
                    ],
                  )
                ],
              ),
              Divider(),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _passController,
                label: 'Contraseña actual',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 20.0),
              CustomTextField(
                controller: _newPassController,
                label: 'Nueva Contraseña',
                icon: Icons.lock,
                isPassword: true,
              ),
              CustomTextField(
                controller: _confirmNewPassController,
                label: 'Confirmación Nueva Contraseña',
                icon: Icons.lock,
                isPassword: true,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttons(){
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 50,
        ),
        ShakeTransition(
          child: Container(
            decoration: BoxDecoration(
              color: !_enviando ? Colors.blue : Constants.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )
            ),
            width: double.infinity,
            height: 50,
            child: ShakeTransition(
              axis: Axis.vertical,
              offset: 140.0,
              duration: Duration(milliseconds: 3000),
              child: CustomRaisedButton(
                action: ()=>Navigator.pop(context),//()=> !_enviando ? _validaSubmit() : (){},
                borderColor: !_enviando ? Colors.blue : Constants.primaryColor,
                primaryColor: !_enviando ? Colors.blue : Constants.primaryColor,
                textColor: Colors.white,
                label: 'Entendido'//'${!_enviando ? 'Guardar' : 'Enviando ...'}'
              ),
            )
          ),
        ),
      ],
    );
  }

  _validaSubmit() async{
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> userInfo = await _sharedActions.getUserInfo();
    _setEnviando();
    if(_formKey.currentState.validate() && await _localValidation(userInfo)){
      if(await _authFirebase.changePass(userInfo['user'], _passController.text ,_newPassController.text)){
        await _sharedActions.setPassInfo(_newPassController.text);
        _firebaseProvider.actualizaTipoUsuario(userInfo['documentID']);
        _cleanFields();
        _success('Contraseña actualizada');
      }else{
        _error('Error desconocido, revisa tu conexión a internet o vuelve a intentarlo mas tarde');
      }
    }
    _setEnviando();
  }

  _setEnviando(){
    setState(() {_enviando = !_enviando;});
  }

  Future<bool> _localValidation(Map<String, dynamic> userInfo)async{
    if(_passController.text != userInfo['pass']){
      _error('Error La contraseña actual no es correcta');
      return false;
    }else if(_newPassController.text.length < 6){
      _error('Error La nueva contraseña debe tener al menos 6 caracteres');
      return false;
    }else if(_newPassController.text != _confirmNewPassController.text){
      _error('Error La confirmacion de la contraseña no coincide con la nueva contraseña');
      return false;
    }else if(_newPassController.text == _passController.text){
      _error('Error La nueva contraseña debe ser diferente a la actual contraseña');
      return false;
    }
    return true;
  }
  
  _error(String error){
    _customSnakBar.showSnackBar(
      error,
      Duration(milliseconds: 5000),
      Colors.pink,
      Icons.error_outline,
      _scaffoldKey
    );
  }

  _success(String msj){
    _customSnakBar.showSnackBarSuccess(
      msj, 
      Duration(milliseconds: 2000), 
      Constants.primaryColor, 
      Icons.check_circle_outline, 
      _scaffoldKey
    );
  }

  _cleanFields(){
    _passController.text = '';
    _newPassController.text = '';
    _confirmNewPassController.text = '';
  }
}