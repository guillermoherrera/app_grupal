import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/cat_estados_model.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DireccionForm extends StatefulWidget {
  const DireccionForm({Key key,
    this.direccion1,
    this.ciudad,
    this.colonia,
    this.cp,
    this.estadoCod,
    this.municipio,
    this.paisCod,
    this.pageController,
    this.backPage
  }) : super(key: key);

  final TextEditingController direccion1;
  final TextEditingController colonia;
  final TextEditingController municipio;
  final TextEditingController ciudad;
  final TextEditingController estadoCod;
  final TextEditingController cp;
  final TextEditingController paisCod;
  final PageController pageController;
  final VoidCallback backPage;

  @override
  _DireccionFormState createState() => _DireccionFormState();
}

class _DireccionFormState extends State<DireccionForm> {
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
    CatEstado estado = CatEstado(codigo: 'DUR', estado: 'DURANGO');
    estados.add(estado);
    estado = CatEstado(codigo: 'COA', estado: 'COAHUILA');
    estados.add(estado);
    estado = CatEstado(codigo: 'AGS', estado: 'AGUASCALIENTES');
    estados.add(estado);
    setState(() {});
  }

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
        child: Text('Dirección'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      _buttonBack(),
      CustomTextField(
        label: 'Calle y número', 
        controller: widget.direccion1,
        maxLength: 50,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'Colonia', 
              controller: widget.colonia,
              maxLength: 50,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Municipio / Delegación', 
              controller: widget.municipio,
              maxLength: 50,
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
              controller: widget.ciudad,
              maxLength: 50,
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
              controller: widget.cp,
              maxLength: 5,
              textType: TextInputType.number,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'País', 
              controller: widget.paisCod,
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
                  widget.estadoCod.text = estadoSel;
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
}