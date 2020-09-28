import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/widgets/custom_raised_button.dart';
import 'package:app_grupal/widgets/custom_text_field.dart';
import 'package:app_grupal/widgets/shake_transition.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class DatosForm extends StatefulWidget {
  const DatosForm({Key key,
    this.importeCapitalController,
    this.curpController,
    this.fechaNacimientoController,
    this.nombreController,
    this.primerApellidoController,
    this.rfcController,
    this.segundoApellidoController,
    this.sengundoNombreController,
    this.telefonoController
  }) : super(key: key);

  final TextEditingController importeCapitalController;
  final TextEditingController curpController;
  final TextEditingController nombreController;
  final TextEditingController sengundoNombreController;
  final TextEditingController primerApellidoController;
  final TextEditingController segundoApellidoController;
  final TextEditingController fechaNacimientoController;
  final TextEditingController rfcController;
  final TextEditingController telefonoController;

  @override
  _DatosFormState createState() => _DatosFormState();
}

class _DatosFormState extends State<DatosForm> with AutomaticKeepAliveClientMixin{
  DateTime now = new DateTime.now();
  DateTime selectedDate;

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
        controller: widget.importeCapitalController,
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
              controller: widget.curpController,
              maxLength: 18,
            ),
          ),
          flexPadded(
            ShakeTransition(
              axis: Axis.vertical,
              child: Container(
                padding: EdgeInsets.only(bottom: 20.0),
                margin: EdgeInsets.only(right: 5.0),
                child: CustomRaisedButton(
                  elevation: 8.0,
                  borderColor: Colors.blue,
                  textColor: Colors.white,
                  primaryColor: Colors.blue,
                  label: 'Consultar Curp',
                  action: (){},
                ),
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
              controller: widget.nombreController,
              maxLength: 50,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Segundo Nombre', 
              controller: widget.sengundoNombreController,
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
              controller: widget.primerApellidoController,
              maxLength: 50,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Segundo Apellido', 
              controller: widget.segundoApellidoController,
              maxLength: 50,
            ),
            isRight: false
          ),  
        ],
      ),
      _fieldFechaNacimiento(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          flexPadded(
            CustomTextField(
              label: 'RFC', 
              controller: widget.rfcController,
              maxLength: 13,
            ),
          ),
          flexPadded(
            CustomTextField(
              label: 'Teléfono', 
              controller: widget.telefonoController,
              maxLength: 10,
            ),
            isRight: false
          ),  
        ],
      ),
    ];
  }

  Widget _fieldFechaNacimiento(){
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: Container(
          padding: EdgeInsets.only(top:10.0),
          child: CustomTextField(
            label: 'Fecha de Nacimiento', 
            controller: widget.fechaNacimientoController,
            icon: Icons.calendar_today,
            maxLength: 10,
          ),
        ),
      ),
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

  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    selectedDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      //locale: const Locale('es'),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime(now.year - 1));
    if (picked != null){
      if(selectedDate.difference(picked).inDays >= 0){
        setState(() {
          selectedDate = picked;
          widget.fechaNacimientoController.text = formatDate(selectedDate, [dd, '/', mm, '/', yyyy]);
          //getCurpRfc();
        });
      }else{
        widget.fechaNacimientoController.text = "No válido".toUpperCase();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}