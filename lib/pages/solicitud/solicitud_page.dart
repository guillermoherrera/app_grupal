import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/solicitud/datos_form.dart';
import 'package:app_grupal/pages/solicitud/direccion_form.dart';
import 'package:app_grupal/pages/solicitud/documentos_form.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/components/body_content.dart';

class SolicitudPage extends StatefulWidget {
  @override
  _SolicitudPageState createState() => _SolicitudPageState();
}

class _SolicitudPageState extends State<SolicitudPage> {
  PageController _pageController;
  int _currentPage = 0;
  final _importeCapitalController = TextEditingController();
  final _curp = TextEditingController();
  final _nombre = TextEditingController();
  final _sengundoNombre = TextEditingController();
  final _primerApellido = TextEditingController();
  final _segundoApellido = TextEditingController();
  final _fechaNacimiento = TextEditingController();
  final _rfc = TextEditingController();
  final _telefono = TextEditingController();

  final _direccion1 = TextEditingController();
  final _colonia = TextEditingController();
  final _municipio = TextEditingController();
  final _ciudad = TextEditingController();
  final _estadoCod = TextEditingController();
  final _cp = TextEditingController();
  final _paisCod = TextEditingController();
  
  @override
  void initState() {
    _paisCod.text = "MX";
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
                  Text('Grupo XXX'.toUpperCase(), style: Constants.mensajeCentral2),
                  Text('Paso ${_currentPage+1}/3'.toUpperCase(), style: Constants.mensajeCentral3),
                ]
              ),
              Column(
                children: [
                  Icon(Icons.person_add, color: Constants.primaryColor,),
                  Text('xxx', style: TextStyle(fontSize: 11.0, color: Constants.primaryColor))
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
                DatosForm(
                  importeCapitalController: _importeCapitalController,
                  curp: _curp,
                  nombre: _nombre,
                  sengundoNombre: _sengundoNombre,
                  primerApellido: _primerApellido,
                  segundoApellido: _segundoApellido,
                  fechaNacimiento: _fechaNacimiento,
                  rfc: _rfc,
                  telefono: _telefono,
                ),
                DireccionForm(
                  direccion1 : _direccion1,
                  colonia : _colonia,
                  municipio : _municipio,
                  ciudad : _ciudad,
                  estadoCod : _estadoCod,
                  cp : _cp,
                  paisCod : _paisCod,
                  pageController: _pageController,
                  backPage: _backPage
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
            child: CustomRaisedButton(
              action: ()=>_actionBottomButton(),
              borderColor: Colors.blue,
              primaryColor: Colors.blue,
              textColor: Colors.white,
              label: _currentPage == 2 ? 'Guardar' : 'Siguiente'
            ),
          ),
        ),
      ],
    );
  }

  _actionBottomButton(){
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }

    setState(() {_currentPage += 1;});
  }

  _backPage(){
    setState(() {_currentPage -= 1;});
  }
}