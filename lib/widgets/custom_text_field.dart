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
    @required this.controller
  }) : super(key: key);
  
  final String label;
  final String errorEmpty;
  final IconData icon;
  final TextInputType textType;
  final bool checkEmpty;
  final bool isPassword;
  final TextEditingController controller;

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
      validator: (value){
        return _validations(value);
      },
    );
  }

  String _validations(String value){
    if(widget.checkEmpty && value.isEmpty) return widget.errorEmpty; 
    return null;
  }

  InputDecoration _decorationField(String label){
    return InputDecoration(
      prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
      labelText: label,
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