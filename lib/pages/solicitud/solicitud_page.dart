import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/solicitud/datos_form.dart';
import 'package:app_grupal/pages/solicitud/direccion_form.dart';
import 'package:app_grupal/pages/solicitud/documentos_form.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/components/body_content.dart';

class SolicitudPage extends StatefulWidget {
  const SolicitudPage({
    Key key, 
    this.params
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _SolicitudPageState createState() => _SolicitudPageState();
}

class _SolicitudPageState extends State<SolicitudPage> {
  final _formKeyDatos = new GlobalKey<FormState>();
  final _formKeyDireccion = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _customSnakBar = new CustomSnakBar();
  PageController _pageController;
  int _currentPage = 0;
  final _importeCapitalController = TextEditingController();
  final _curpController = TextEditingController();
  final _nombreController = TextEditingController();
  final _sengundoNombreController = TextEditingController();
  final _primerApellidoController = TextEditingController();
  final _segundoApellidoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _rfcController = TextEditingController();
  final _telefonoController = TextEditingController();

  final _direccion1Controller = TextEditingController();
  final _coloniaController = TextEditingController();
  final _municipioController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _estadoCodController = TextEditingController();
  final _cpController = TextEditingController();
  final _paisCodController = TextEditingController();
  
  @override
  void initState() {
    _paisCodController.text = "MX";
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
      leading: ShakeTransition(child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context))),
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
                  Text('Nueva Solicitud'.toUpperCase(), style: Constants.mensajeCentral),
                  Text('Grupo ${widget.params['nombreGrupo']}'.toUpperCase(), style: Constants.mensajeCentral2),
                  //Text('Paso ${_currentPage+1}/3'.toUpperCase(), style: Constants.mensajeCentral3),
                ]
              ),
              Column(
                children: [
                  Icon(Icons.person_add, color: Constants.primaryColor,),
                  Text('${_currentPage+1}/3'.toUpperCase(), style: TextStyle(fontSize: 11.0, color: Constants.primaryColor, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Divider(),
          SizedBox(height: 10.0),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Form(
                  key: _formKeyDatos,
                  child: DatosForm(
                    importeCapitalController: _importeCapitalController,
                    curpController: _curpController,
                    nombreController: _nombreController,
                    sengundoNombreController: _sengundoNombreController,
                    primerApellidoController: _primerApellidoController,
                    segundoApellidoController: _segundoApellidoController,
                    fechaNacimientoController: _fechaNacimientoController,
                    rfcController: _rfcController,
                    telefonoController: _telefonoController,
                  ),
                ),
                Form(
                  key: _formKeyDireccion,
                  child: DireccionForm(
                    direccion1Controller : _direccion1Controller,
                    coloniaController : _coloniaController,
                    municipioController : _municipioController,
                    ciudadController : _ciudadController,
                    estadoCodController : _estadoCodController,
                    cpController : _cpController,
                    paisCodController : _paisCodController,
                    pageController: _pageController,
                    backPage: _backPage
                  ),
                ),
                DocumentosForm(
                  pageController: _pageController,
                  backPage: _backPage
                )
              ],
            ),
          ),
        ],
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
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              )
            ),
            width: double.infinity,
            height: 50,
            child: _currentPage == 2 ?
            ShakeTransition(
              axis: Axis.vertical,
              offset: 70.0,
              duration: Duration(milliseconds: 3000),
              child: CustomRaisedButton(
                action: ()=>_actionBottomButton(),
                borderColor: Colors.blue,
                primaryColor: Colors.blue,
                textColor: Colors.white,
                label: 'Guardar'
              ),
            ) : 
            CustomRaisedButton(
              action: ()=>_actionBottomButton(),
              borderColor: Colors.blue,
              primaryColor: Colors.blue,
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
    if((_currentPage == 0 && _formKeyDatos.currentState.validate()) || (_currentPage == 1 && _formKeyDireccion.currentState.validate())){
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }

      setState(() {_currentPage += 1;});
    }else{
      _error('Error por favor revisa la información capturada');
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

  _backPage(){
    setState(() {_currentPage -= 1;});
  }
}