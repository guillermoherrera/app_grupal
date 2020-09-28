import 'package:flutter/material.dart';
import 'package:app_grupal/helpers/utilerias.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key key,
    @required this.label,
    this.icon,
    this.errorEmpty = 'Ingresa este campo',
    this.textType = TextInputType.emailAddress,
    this.checkEmpty = true,
    this.isPassword = false,
    this.check500s = false,
    this.checkMaxLength = false,
    this.checkRfc = false,
    this.enable = true,
    this.onlyCharacters = false,
    @required this.controller,
    this.maxLength = 100,
    this.onchangeMethod,
    this.enableUpperCase = false,
  }) : super(key: key);
  
  final String label;
  final String errorEmpty;
  final IconData icon;
  final TextInputType textType;
  final bool checkEmpty;
  final bool check500s;
  final bool isPassword;
  final TextEditingController controller;
  final int maxLength;
  final bool enable;
  final bool checkMaxLength;
  final bool checkRfc;
  final bool onlyCharacters;
  final bool enableUpperCase;
  final void Function(String) onchangeMethod;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool watchPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, 
      decoration: _decorationField(widget.label),
      autocorrect: false,
      inputFormatters: widget.enableUpperCase ? [UpperCaseTextFormatter()] : [],
      keyboardType: widget.textType,
      obscureText: widget.isPassword ? !watchPassword : false,
      maxLength: widget.maxLength,
      enabled: widget.enable,
      validator: (value){
        return _validations(value);
      },
      onChanged: (value) => _onChange != null ? _onChange(value) : (){},
    );
  }

  _onChange(String value){
    widget.onchangeMethod(value);
  }

  String _validations(String value){
    if(widget.onlyCharacters){
      value = value.replaceAll(RegExp(r"[^\s\w]"), "");//quitar simbolos
      value = value.replaceAll(" ", "");//quitar espacios
    }

    if(widget.checkEmpty && value.isEmpty) return widget.errorEmpty; 
    if(widget.check500s && (double.parse(value) <= 0 || double.parse(value)%500 > 0 )) return 'Ingresa 500, 1000, 1500, 2000... XXXX)';
    if(widget.checkMaxLength && value.length < widget.maxLength) return 'Completa este campo'; 
    if(widget.checkRfc && (value.length != 10 && value.length != 13)) return 'Completa el RFC';
    return null;
  }

  InputDecoration _decorationField(String label){
    return InputDecoration(
      prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
      labelText: label.toUpperCase(),
      fillColor: Color(0xfff2f2f2),
      filled: true,
      border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      suffixIcon: widget.isPassword ? IconButton(
        icon: Icon(!watchPassword ? Icons.visibility : Icons.visibility_off),
        onPressed: (){setState(() {
          watchPassword = !watchPassword;
        });}
      ) : null
    );
  }
}