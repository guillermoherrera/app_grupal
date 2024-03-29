import 'package:app_grupal/classes/shared_preferences.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/documentos_model.dart';
import 'package:app_grupal/models/solicitud_model.dart';
import 'package:app_grupal/pages/solicitud/datos_form.dart';
import 'package:app_grupal/pages/solicitud/direccion_form.dart';
import 'package:app_grupal/pages/solicitud/documentos_form.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_dialog.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_snack_bar.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:date_format/date_format.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

import 'package:app_grupal/widgets/custom_app_bar.dart';
import 'package:app_grupal/components/body_content.dart';

class SolicitudPage extends StatefulWidget {
  const SolicitudPage({
    Key key, 
    this.params,
    this.getNewIntegrante
  }) : super(key: key);

  final Map<String, dynamic> params;
  final void Function(int) getNewIntegrante;

  @override
  _SolicitudPageState createState() => _SolicitudPageState();
}

class _SolicitudPageState extends State<SolicitudPage> {
  final _formKeyDatos = new GlobalKey<FormState>();
  final _formKeyDireccion = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _customSnakBar = new CustomSnakBar();
  final _sharedActions = SharedActions();
  PageController _pageController;
  String _userID;
  int _currentPage = 0;
  int intentoCurp = 0; //auxiliar para la validación de las palabras altisonantes
  List<Documento> _documentos = List();
  List<Documento> _documentosEditar = List();
  Solicitud _solicitud = new Solicitud();
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
    _getUserID();
    _loadInfo();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _getUserID()async{
    _userID = await _sharedActions.getUserId();
  }

  _loadInfo()async{
    await Future.delayed(Duration(milliseconds: 1000));
    if(widget.params['edit'] == true){
      _getSolicitudEdit();
    }else{
      _getSolicitudFromShared();
    }
  }

  _getSolicitudEdit()async{
    print('EDIT ###');
    Solicitud solicitud = await DBProvider.db.getSolicitudById(widget.params['idSolicitud']);
    _fillSolicitud(solicitud);
    _documentosEditar = await DBProvider.db.getDocumentosbySolicitud(solicitud.idSolicitud);
  }

  _getSolicitudFromShared() async{
    print('SHARED ###');
    Solicitud solicitud = await _sharedActions.getSolicitud();
    _fillSolicitud(solicitud);
  }

  _fillSolicitud(Solicitud solicitud){
    if(solicitud.capital > 0){
      String fechaFromMS = formatDate(DateTime.fromMillisecondsSinceEpoch(solicitud.fechaNacimiento).toUtc(), [dd, '/', mm, '/', yyyy]);
      _importeCapitalController.text = '${solicitud.capital.toStringAsFixed(0)}';
      _nombreController.text = solicitud.nombre;
      _sengundoNombreController.text = solicitud.segundoNombre;
      _primerApellidoController.text = solicitud.primerApellido;
      _segundoApellidoController.text = solicitud.segundoApellido;
      _fechaNacimientoController.text = fechaFromMS;
      _curpController.text = solicitud.curp;
      _rfcController.text = solicitud.rfc;
      _telefonoController.text = solicitud.telefono;
      _direccion1Controller.text = solicitud.direccion1;
      _coloniaController.text = solicitud.coloniaPoblacion;
      _municipioController.text = solicitud.delegacionMunicipio;
      _ciudadController.text = solicitud.ciudad;
      _estadoCodController.text = solicitud.estado;
      _cpController.text = solicitud.cp != null ? '${solicitud.cp}' : solicitud.cp;
      _paisCodController.text = solicitud.pais;
    }
  }

  List<String> _datosCapturados(){
    List<String> datos = [];
    datos.add(_importeCapitalController.text);
    datos.add('${_nombreController.text} ${_sengundoNombreController.text} ${_primerApellidoController.text} ${_segundoApellidoController.text}');
    datos.add(_fechaNacimientoController.text);
    datos.add(_curpController.text);
    datos.add(_rfcController.text);
    datos.add(_telefonoController.text);
    datos.add('${_direccion1Controller.text} ${_coloniaController.text} ${_cpController.text} ${_municipioController.text} ${_ciudadController.text}, ${_estadoCodController.text}. ${_paisCodController.text}.');
    
    return datos;
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
                  fillDocumentos: _fillDocumentos,
                  documentos: _documentosEditar,
                  backPage: _backPage,
                  datosCapturados: _datosCapturados,
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
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )
            ),
            width: double.infinity,
            height: 50,
            child: _currentPage == 2 ?
            ShakeTransition(
              axis: Axis.vertical,
              offset: 140.0,
              duration: Duration(milliseconds: 3000),
              child: CustomRaisedButton(
                action: ()=> widget.params['edit'] == true ? _updateBottomButton() : _saveBottomButton(),
                borderColor: Colors.blue,
                primaryColor: Colors.blue,
                textColor: Colors.white,
                label: widget.params['edit'] == true ? 'Actualizar' : 'Guardar'
              ),
            ) : 
            CustomRaisedButton(
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
    if((_currentPage == 0 && _formKeyDatos.currentState.validate()) || (_currentPage == 1 && _formKeyDireccion.currentState.validate())){
      if(getChekCurpRfc()){
        if(checkEstado()){
          
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage + 1,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
            if(!(widget.params['edit'] == true)) _saveSharedPreferences(_currentPage);
            setState(() {_currentPage += 1;});
          }
        
        }else{
          _error('Ingresa el estado.');  
        }
      }else{
        _error('Error en el formato de la CURP y/o RFC.');
      }
    }else{
      _error('Error por favor revisa la información capturada');
    }
  }

  _saveSharedPreferences(int _currentPage){
    
    if(_currentPage == 0){
      String fechaString = _fechaNacimientoController.text;
      int fechaToMS = DateTime.parse('${fechaString.substring(6,10)}-${fechaString.substring(3,5)}-${fechaString.substring(0,2)}').millisecondsSinceEpoch;
      _solicitud.capital = double.parse(_importeCapitalController.text);
      _solicitud.nombre = _nombreController.text;
      _solicitud.segundoNombre = _sengundoNombreController.text;
      _solicitud.primerApellido = _primerApellidoController.text;
      _solicitud.segundoApellido = _segundoApellidoController.text;
      _solicitud.fechaNacimiento = fechaToMS;
      _solicitud.curp = _curpController.text;
      _solicitud.rfc = _rfcController.text;
      _solicitud.telefono = _telefonoController.text;
    }else if(_currentPage == 1){
      _solicitud.direccion1 = _direccion1Controller.text;
      _solicitud.coloniaPoblacion = _coloniaController.text;
      _solicitud.delegacionMunicipio = _municipioController.text;
      _solicitud.ciudad = _ciudadController.text;
      _solicitud.estado = _estadoCodController.text;
      _solicitud.cp = int.parse(_cpController.text);
      _solicitud.pais = _paisCodController.text;
    }
    _sharedActions.saveSolicitud(_solicitud, _currentPage);
  }

  _updateBottomButton(){
    List<Documento> documentosFaltantes = _documentos.where((d) => d.documento == null).toList();
    if(documentosFaltantes.length == 0){
      CustomDialog customDialog = CustomDialog();
      customDialog.showCustomDialog(
        context,
        title: 'Actualizar Solicitud',
        icon: Icons.error_outline,
        textContent: 'Antes de actualizar la solicitud confirme que ha revisado que los DATOS DEL CLIENTE se han capturado correctamente.\n\n¿La información capturada es correcta?',
        cancel: 'Revisar',
        cntinue: 'Si, actualizar solicitud',
        action: _actualizarSolicitud
      );
    }else{
      _error('Error ${documentosFaltantes.length} documento(s) faltante(s)');
    }
  }

  _actualizarSolicitud() async{
    _solicitud.contratoId = widget.params['contratoId'];
    _solicitud.nombreGrupo = widget.params['nombreGrupo'];
    _solicitud.idGrupo = widget.params['idGrupo'];
    _solicitud.status = 0;
    _solicitud.tipoContrato = 2;
    _solicitud.userID = _userID;
    _solicitud.idSolicitud = widget.params['idSolicitud'];
    await DBProvider.db.updateSolicitud(_solicitud).then((id)async{
      for(Documento e in _documentos){
        e.idSolicitud = _solicitud.idSolicitud;
        int id = await DBProvider.db.updateDocumento(e);
        print(id);
      }
      Navigator.pop(context);//cierra el popUp
      widget.getNewIntegrante(_solicitud.idSolicitud);
      _success('Solicitud Actualizada con éxito');
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.pop(context);//cierra el formulairio
    });
  }

  _saveBottomButton(){
    List<Documento> documentosFaltantes = _documentos.where((d) => d.documento == null).toList();
    if(documentosFaltantes.length == 0){
      CustomDialog customDialog = CustomDialog();
      customDialog.showCustomDialog(
        context,
        title: 'Crear Solicitud',
        icon: Icons.error_outline,
        textContent: 'Antes de crear la solicitud confirme que ha revisado que los DATOS DEL CLIENTE se han capturado correctamente.\n\n¿La información capturada es correcta?',
        cancel: 'Revisar',
        cntinue: 'Si, crear solicitud',
        action: _crearSolicitud
      );
    }else{
      _error('Error ${documentosFaltantes.length} documento(s) faltante(s)');
    }
  }

  _crearSolicitud() async{
    _solicitud.contratoId = widget.params['contratoId'];
    _solicitud.nombreGrupo = widget.params['nombreGrupo'];
    _solicitud.idGrupo = widget.params['idGrupo'];
    _solicitud.status = 0;
    _solicitud.tipoContrato = 2;
    _solicitud.userID = _userID;
    await DBProvider.db.nuevaSolicitud(_solicitud).then((id)async{
      _solicitud.idSolicitud = id;
      for(Documento e in _documentos){
        e.idSolicitud = _solicitud.idSolicitud;
        int id = await DBProvider.db.nuevoDocumento(e);
        print(id);
      }
    });    
    Navigator.pop(context);//cierra el popUp
    //int id = await DBProvider.db.nuevaSolicitud(_solicitud);
    if(_solicitud.idSolicitud != null && _solicitud.idSolicitud > 0){
      widget.getNewIntegrante(_solicitud.idSolicitud);
      _success('Solicitud creada con éxito');
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.pop(context);//cierra el formulairio
      //_sharedActions.removeSolicitud();
    }else{
      _error('Error desconocido');
    }
  }

  _fillDocumentos(List<Documento> documentosForm){
    _documentos = documentosForm;
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

  _backPage(){
    setState(() {_currentPage -= 1;});
  }

  bool checkEstado(){
    if(_currentPage == 1){
      if(_estadoCodController.text.isEmpty || _estadoCodController.text == null){
        return false;
      }else{
        return true;
      }
    }else{
      return true;
    }
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