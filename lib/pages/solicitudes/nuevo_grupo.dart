import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/components/body_content.dart';
import 'package:app_grupal/components/page_route_builder.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/grupos_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

class NuevoGrupoPage extends StatefulWidget {
  const NuevoGrupoPage({
    Key key,
    this.params,
    this.getLastGrupos,
    this.sincroniza
  }) : super(key: key);

  final Map<String, dynamic> params;
  final VoidCallback getLastGrupos;
  final Future<bool> Function() sincroniza;
  
  @override
  _NuevoGrupoPageState createState() => _NuevoGrupoPageState();
}

class _NuevoGrupoPageState extends State<NuevoGrupoPage> {
  final _sharedActions = SharedActions();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKeyDatos = new GlobalKey<FormState>();
  final _nombreGrupoController = TextEditingController();
  final _customSnakBar = new CustomSnakBar();
  final _customRoute = CustomRouteTransition();
  String userID;

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
      heroTag: 'logo',
      leading: ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios, size: 40.0,), onPressed: ()=>Navigator.pop(context))),
    );
  }

  Widget _formulario(){
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nuevo Grupo'.toUpperCase(), style: Constants.mensajeCentral),
                ]
              ),
              Column(
                children: [
                  Icon(Icons.group_add, color: Constants.primaryColor,),
                  Text('1/1'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Divider(),
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: _form(),
                ),
              ),
            ),
          )
        ]
      )
    );
  }

  List<Widget> _form(){
    return [
      Container(
        child: Text('Datos del Grupo'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      SizedBox(
        height: 10.0,
      ),
      CircleAvatar(
        backgroundColor: Colors.grey[100],
        radius: 70.0,
        child: Icon(Icons.group_add, color: Colors.grey, size: 50.0),
      ),
      SizedBox(
        height: 10.0,
      ),
      Form(
      key: _formKeyDatos,
      child: CustomTextField(
          label: 'Nombre del grupo', 
          controller: _nombreGrupoController,
          maxLength: 50,
          enableUpperCase: true,
        ),
      )
    ];
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
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )
            ),
            width: double.infinity,
            height: 50,
            child: CustomRaisedButton(
              action: ()=>_actionBottomButton(),
              borderColor: Colors.blueAccent,
              primaryColor: Colors.blueAccent,
              textColor: Colors.white,
              label: 'Siguiente'
            ),
          ),
        ),
      ],
    );
  }

  _actionBottomButton(){
    FocusScope.of(context).requestFocus(FocusNode());
    if(_formKeyDatos.currentState.validate()){
      CustomDialog customDialog = CustomDialog();
      customDialog.showCustomDialog(
        context,
        title: 'Crear Grupo',
        icon: Icons.error_outline,
        textContent: 'Desea crear el grupo con el nombre ${_nombreGrupoController.text}?',
        cancel: 'Cancelar',
        cntinue: 'Si, crear grupo',
        action: _crearGrupo
      );
    }else{
      _error('Error al crear el grupo.');
    }
  }

  _crearGrupo() async{
    Navigator.pop(context);
    userID = await _sharedActions.getUserId();
    Grupo grupo = Grupo(
      cantidadSolicitudes: 0,
      importeGrupo: 0,
      nombreGrupo: _nombreGrupoController.text,
      status: 0,
      userID: userID,
      contratoId: 0
    );
    try{
      DBProvider.db.nuevoGrupo(grupo).then((value)async{
        Navigator.pushReplacement(context, _customRoute.crearRutaSlide(Constants.grupoPage, {'nombre': _nombreGrupoController.text, 'idGrupo': value}, getLastGrupos: widget.getLastGrupos, sincroniza: widget.sincroniza));
        _nombreGrupoController.text = "";
        setState((){});
      });
    }catch(e){
      _error('No pudo crearse el grupo.\n$e');
    }
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
}