import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DatosForm extends StatelessWidget {
  const DatosForm({Key key,
    this.importeCapitalController,
    this.curp,
    this.fechaNacimiento,
    this.nombre,
    this.primerApellido,
    this.rfc,
    this.segundoApellido,
    this.sengundoNombre,
    this.telefono
  }) : super(key: key);

  final TextEditingController importeCapitalController;
  final TextEditingController curp;
  final TextEditingController nombre;
  final TextEditingController sengundoNombre;
  final TextEditingController primerApellido;
  final TextEditingController segundoApellido;
  final TextEditingController fechaNacimiento;
  final TextEditingController rfc;
  final TextEditingController telefono;

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
        child: Text('Datos Personales'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      Row(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('-'),
          ),
        ],
      ),
      CustomTextField(
        label: 'Importe Capital', 
        controller: importeCapitalController,
        icon: Icons.attach_money,
        maxLength: 6,
        textType: TextInputType.number,
        check500s: true,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'Curp', 
              controller: curp,
              maxLength: 18,
            ),
          ),
          flexPadded(
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: CustomRaisedButton(
                borderColor: Colors.blue,
                textColor: Colors.white,
                primaryColor: Colors.blue,
                label: 'Consultar Curp'
              ),
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
              label: 'Nombre', 
              controller: importeCapitalController,
              maxLength: 50,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Segundo Nombre', 
              controller: importeCapitalController,
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
              label: 'Primer Apellido', 
              controller: importeCapitalController,
              maxLength: 50,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Segundo Apellido', 
              controller: importeCapitalController,
              maxLength: 50,
            ),
            isRight: false
          ),  
        ],
      ),
      Container(
        padding: EdgeInsets.only(top:10.0),
        child: CustomTextField(
          label: 'Fecha de Nacimiento', 
          controller: importeCapitalController,
          icon: Icons.calendar_today,
          maxLength: 10,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'RFC', 
              controller: importeCapitalController,
              maxLength: 13,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Teléfono', 
              controller: importeCapitalController,
              maxLength: 10,
            ),
            isRight: false
          ),  
        ],
      ),
    ];
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