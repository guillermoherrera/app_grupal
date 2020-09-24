import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key key,
    @required this.label,
    this.icon,
    this.errorEmpty = 'Completa este campo',
    this.textType = TextInputType.emailAddress,
    this.checkEmpty = true,
    this.isPassword = false,
    this.check500s = false,
    @required this.controller,
    this.maxLength = 100
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
      keyboardType: widget.textType,
      obscureText: widget.isPassword ? !watchPassword : false,
      maxLength: widget.maxLength,
      validator: (value){
        return _validations(value);
      },
    );
  }

  String _validations(String value){
    if(widget.checkEmpty && value.isEmpty) return widget.errorEmpty; 
    if(widget.check500s && (double.parse(value) <= 0 || double.parse(value)%500 > 0 )) return 'Ingresa 500, 1000, 1500, 2000... XXXX)';
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