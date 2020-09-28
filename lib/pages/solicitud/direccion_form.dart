import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/cat_estados_model.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DireccionForm extends StatefulWidget {
  const DireccionForm({Key key,
    this.direccion1Controller,
    this.ciudadController,
    this.coloniaController,
    this.cpController,
    this.estadoCodController,
    this.municipioController,
    this.paisCodController,
    this.pageController,
    this.backPage
  }) : super(key: key);

  final TextEditingController direccion1Controller;
  final TextEditingController coloniaController;
  final TextEditingController municipioController;
  final TextEditingController ciudadController;
  final TextEditingController estadoCodController;
  final TextEditingController cpController;
  final TextEditingController paisCodController;
  final PageController pageController;
  final VoidCallback backPage;

  @override
  _DireccionFormState createState() => _DireccionFormState();
}

class _DireccionFormState extends State<DireccionForm> with AutomaticKeepAliveClientMixin{
  var estadoSelected;
  String estadoLabel = "Estado";
  Color estadoColorSelected = Colors.grey[600];
  List<CatEstado> estados = List();

  @override
  void initState() {
    _fillEstados();
    super.initState();
  }

  _fillEstados() async{
    CatEstado estado;
    await DBProvider.db.getCatEstados().then((list) => {
      list.forEach((e) {
        estado = CatEstado(codigo: e.codigo, estado: e.estado);
        estados.add(estado);
      }) 
    });
    estados.sort((a, b) => a.estado.compareTo(b.estado));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        child: Text('Dirección'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      _buttonBack(),
      CustomTextField(
        label: 'Calle y número', 
        controller: widget.direccion1Controller,
        maxLength: 50,
        enableUpperCase: true,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'Colonia', 
              controller: widget.coloniaController,
              maxLength: 50,
              enableUpperCase: true,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Municipio / Delegación', 
              controller: widget.municipioController,
              maxLength: 50,
              enableUpperCase: true,
            ),
            isRight: false
          ),  
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'Ciudad', 
              controller: widget.ciudadController,
              maxLength: 50,
              enableUpperCase: true,
            ),
          ),
          flexPadded(
            _estadosField(),
            isRight: false
          ),  
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'Código Postal', 
              controller: widget.cpController,
              maxLength: 5,
              textType: TextInputType.number,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'País', 
              controller: widget.paisCodController,
              maxLength: 50,
              enable: false,
            ),
            isRight: false
          ),  
        ],
      ),
    ];
  }

  Widget _estadosField(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap:(){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: DropdownButton(
              items: estados.map((f)=>DropdownMenuItem(
                child: Text(f.estado),
                value: f.codigo
              )).toList(),
              onChanged: MediaQuery.of(context).viewInsets.bottom == 0 ? (estadoSel){
                setState(() {
                  widget.estadoCodController.text = estadoSel;
                  estadoSelected = estadoSel;
                  estadoLabel = estados.firstWhere((f)=>f.codigo == estadoSel).estado;
                });
              } : null,
              value: estadoSelected,
              isExpanded: true,
              underline: Container(color: Colors.grey),
              hint: Text(estadoLabel.toUpperCase(), style: TextStyle(color: estadoColorSelected)),
            )
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(bottom:20.0),
      height: 55.0,
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.grey[600], style: BorderStyle.solid, width: 1),
      ),
    );
  }

  Widget _buttonBack(){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: (){
              if (widget.pageController.hasClients) {
                widget.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                );
              }
              widget.backPage();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 10.0, color: Colors.blue),
                Text('Datos personales'.toUpperCase(), style: TextStyle(color: Colors.blue)),
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

  @override
  bool get wantKeepAlive => true;
}