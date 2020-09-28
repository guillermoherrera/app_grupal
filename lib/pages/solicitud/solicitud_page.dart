import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/pages/solicitud/datos_form.dart';
import 'package:app_grupal/pages/solicitud/direccion_form.dart';
import 'package:app_grupal/pages/solicitud/documentos_form.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:diacritic/diacritic.dart';
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
  int intentoCurp = 0; //auxiliar para la validación de las palabras altisonantes 
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
                    getCheckCurpRFc: getChekCurpRfc
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
      if(getChekCurpRfc()){
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }

        setState(() {_currentPage += 1;});
      }else{
        _error('Error en el formato de la CURP y/o RFC.');
      }
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

  bool getChekCurpRfc(){
    String curpStr = "", nomPila;
    bool result = false;
    List<String> vocales = <String>['A','E','I','O','U','a','e','i','o','u','Á','É','Í','Ó','Ú','á','é','í','ó','ú'];
    List<String> sexo = <String>['M','H'];
    List<String> entFed = <String>['AS','BC','BS','CC','CL','CM','CS','CH','DF','DG',
                                   'GT','GR','HG','JC','MC','MN','MS','NT','NL','OC',
                                   'PL','QT','QR','SP','SL','SR','TC','TS','TL','VZ',
                                   'YN','ZS','NE'];
    List<String> palInc = <String>['BACA','BAKA','BUEI','BUEY','CACA','CACO','CAGA','CAGO','CAKA','CAKO','COGE','COGI','COJA','COJE','COJI',
                                   'COJO','COLA','CULO','FALO','FETO','GETA','GUEI','GUEY','JETA','JOTO','KACA','KACO','KAGA','KAGO','KAKA',
                                   'KAKO','KOGE','KOGI','KOJA','KOJE','KOJI','KOJO','KOLA','KULO','LILO','LOCA','LOCO','LOKA','LOKO','MAME',
                                   'MAMO','MEAR','MEAS','MEON','MIAR','MION','MOCO','MOKO','MULA','MULO','NACA','NACO','PEDA','PEDO','PENE',
                                   'PIPI','PITO','POPO','PUTA','PUTO','QULO','RATA','ROBA','ROBE','ROBO','RUIN','SENO','TETA','VACA','VAGA',
                                   'VAGO','VAKA','VUEI','VUEY','WUEI','WUEY'];                            

    //primer letra primer Apellido
    curpStr = curpStr + (_primerApellidoController.text.length > 0 ? _primerApellidoController.text[0] : 'X');

    //primer vocal primer Apellido
    bool bandera = false;
    for(int i = 1;(bandera == false && _primerApellidoController.text.length > 1); i++){
      if(vocales.contains(_primerApellidoController.text[i])){
        bandera = true;
        curpStr = curpStr + _primerApellidoController.text[i];
      }
      if(_primerApellidoController.text.length == i+1)
        bandera = true;
    }

    //primera letra segundo apellido
    curpStr = curpStr + (_segundoApellidoController.text.length > 0 ? _segundoApellidoController.text[0] : 'X');
    
    //primera letra nombre pila
    if((_nombreController.text == "MARÍA" || _nombreController.text == "JOSÉ" || _nombreController.text == "MARIA" || _nombreController.text == "JOSE") && _sengundoNombreController.text.length > 0){
      nomPila = _sengundoNombreController.text.length > 0 ? _sengundoNombreController.text : _nombreController.text;
      nomPila = nomPila.replaceAll("DE LAS ", "").replaceAll("DE LOS ", "").replaceAll("DE LA ", "").replaceAll("DEL ", "").replaceAll("DE ", "");
      curpStr = curpStr + (nomPila.length > 0 ? nomPila[0] : 'X');
    }else{
      curpStr = curpStr + (_nombreController.text.length > 0 ? _nombreController.text[0] : 'X');
      nomPila = _nombreController.text;
    }

    //validacion tildes y palabras altisonantes
    curpStr = removeDiacritics(curpStr);
    if(palInc.contains(curpStr) && intentoCurp != 4){
      intentoCurp += 1;
      curpStr = curpStr.substring(0,1) + 'X' + curpStr.substring(2);
    }else{
      intentoCurp = 0;
    }

    //fecha de Nacimiento
    if(_fechaNacimientoController.text.length > 9){
      curpStr = curpStr + _fechaNacimientoController.text[8] +_fechaNacimientoController.text [9];
      curpStr = curpStr + _fechaNacimientoController.text[3] +_fechaNacimientoController.text [4];
      curpStr = curpStr + _fechaNacimientoController.text[0] +_fechaNacimientoController.text [1];
    }

    String segConsonantes = "";
    //segunda consonante primer apellido
    bandera = false;
    for(int i = 1;(bandera == false && _primerApellidoController.text.length > 1); i++){
      if(!vocales.contains(_primerApellidoController.text[i])){
        bandera = true;
        segConsonantes = _primerApellidoController.text[i];
      }
      if(_primerApellidoController.text.length == i+1)
        bandera = true;
      if(bandera && segConsonantes.length == 0)
        segConsonantes = 'X';
    }
    
    //segunda consonante segundo apellido
    bandera = false;
    for(int i = 1;(bandera == false && _segundoApellidoController.text.length > 1); i++){
      if(!vocales.contains(_segundoApellidoController.text[i])){
        bandera = true;
        segConsonantes = segConsonantes + _segundoApellidoController.text[i];
      }
      if(_segundoApellidoController.text.length == i+1)
        bandera = true;
      if(bandera && segConsonantes.length == 1)
        segConsonantes = segConsonantes + 'X';
    }
    if(_segundoApellidoController.text.length == 0){segConsonantes = segConsonantes + 'X';}

    //segunda consonante nombre pila
    bandera = false;
    for(int i = 1;(bandera == false && nomPila.length > 1); i++){
      if(!vocales.contains(nomPila[i])){
        bandera = true;
        segConsonantes = segConsonantes + nomPila[i];
      }
      if(nomPila.length == i+1)
        bandera = true;
      if(bandera && segConsonantes.length == 2)
        segConsonantes = segConsonantes + 'X';
    }
    
    //fill 10 caracteres de campos curp y rfc
    if(_curpController.text.length < 18) _curpController.text = curpStr;
    if(_rfcController.text.length < 10) _rfcController.text = curpStr;
    
    //validaciones
    if(_curpController.text.length == 18 && (_rfcController.text.length == 10 || _rfcController.text.length == 13)){
      if(_curpController.text.substring(0,10) == curpStr && _rfcController.text.substring(0,10) == curpStr && sexo.contains(_curpController.text.substring(10,11)) && entFed.contains(_curpController.text.substring(11,13)) && _curpController.text.substring(13,16) == segConsonantes && double.tryParse(_curpController.text.substring(17,18)) != null ){
         result = true; 
      }
    }
    return result;
  }
}