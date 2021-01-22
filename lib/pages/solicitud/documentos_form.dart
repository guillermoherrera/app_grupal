import 'dart:io';

import 'package:app_grupal/widgets/container_shadow.dart';
import 'package:flutter/material.dart';
import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/providers/db_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'image_detail.dart';

class DocumentosForm extends StatefulWidget {
  const DocumentosForm({Key key,
    this.pageController,
    this.backPage,
    this.fillDocumentos,
    this.documentos
  }) : super(key: key);

  final PageController pageController;
  final VoidCallback backPage;
  final void Function(List<Documento>) fillDocumentos;
  final List<Documento> documentos;

  @override
  _DocumentosFormState createState() => _DocumentosFormState();
}

class _DocumentosFormState extends State<DocumentosForm> with AutomaticKeepAliveClientMixin{
  final ImagePicker _picker = ImagePicker();
  List<CatDocumento> _catDocumentos = List();
  List<Documento> _documentos = List();
  List<Item> _books = List();
  @override
  void initState() {
    _getCatDocumentos();
    _getDocumentosEdit();
    _openFirstPanel();
    super.initState();
  }

  _getCatDocumentos() async{
    _catDocumentos = await DBProvider.db.getDocumentos();
    _catDocumentos.forEach((e) {
      final Documento documento = Documento(tipoDocumento: e.tipo, version: 1);
      _documentos.add(documento);
    });
    _books = generateItems();
    setState(() {});
  }

  _getDocumentosEdit()async{
    await Future.delayed(Duration(milliseconds: 1000));
    widget.documentos.forEach((e) {
      var objetoArchivo = _documentos.firstWhere((archivo) => archivo.tipoDocumento == e.tipoDocumento);    
      objetoArchivo.documento = e.documento;
    });
  }

  _openFirstPanel() async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _books[0].isExpanded = true;
    });
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
        child: Text('Documentos'.toUpperCase(), style: Constants.mensajeCentral),
      ),
      _buttonBack(),
      _tableDocuments()
    ];
  }

  List<Item> generateItems() {
    return List.generate(_catDocumentos.length, (int index) {
      return Item(
        headerValue: '${_catDocumentos[index].descDocumento}',
        expandedValue: '${_catDocumentos[index].tipo}',
      );
    });
  }


  Widget _tableDocuments(){
    int indexControl = -1;
    widget.fillDocumentos(_documentos);
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _books[index].isExpanded = !isExpanded;
        });
      },
      children: _books.map<ExpansionPanel>((Item item) {
          indexControl += 1;
          final index = indexControl;
          final int tipo = int.parse(item.expandedValue);
          final String pathFile = _documentos.singleWhere((archivo) => archivo.tipoDocumento == tipo).documento;
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return GestureDetector(
                onTap: (){setState(() {
                  _books[index].isExpanded = !isExpanded;
                });},
                child: Ink(
                  color: Colors.grey[50],
                  child: ListTile(
                    title: Text(item.headerValue, style: Constants.mensajeCentral),
                    subtitle: Row(
                      children: pathFile == null ?[
                        Icon(Icons.error_outline, size: 20.0, color: Colors.yellow[600]),
                        Text(' No seleccionado'.toUpperCase(), style: Constants.mensajeCentral2)
                      ] : [
                        Icon(Icons.check_circle_outline, size: 20.0, color: Constants.primaryColor),
                        Text(' Listo'.toUpperCase(), style: Constants.mensajeCentral2)
                      ]
                    ),
                  ),
                ),
              );
            },
            body: ListTile(
              title: Row(
                children: [
                  _flatButton(icon: Icons.add_a_photo, text: 'Tomar Foto', action: ()=>_getImage(1, tipo)),
                  SizedBox(width: 5.0),
                  _flatButton(icon: Icons.add_photo_alternate, text: 'Abrir Galería', action:()=>_getImage(2, tipo))
                ],
              ),
              //subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: showImage(tipo),
              //onTap: () {
              //  setState(() {
              //    _books.removeWhere((currentItem) => item == currentItem);
              //  });
              //}
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
    );
  }

  Widget _flatButton({VoidCallback action, @required IconData icon, @required String text}){
    return ContainerShadow(
      child: FlatButton(
        onPressed: action,
        child: Column(
          children: [
            Icon(icon, color: Constants.primaryColor, size: 20.0),
            Text(text.toUpperCase(), style: TextStyle(color: Constants.primaryColor, fontSize: 10.0))
          ]
        )
      ),
    );
  }

  _getImage(int opc, int tipo) async{
    PickedFile auxFile;
    try{
      if(opc == 1)
        auxFile = await _picker.getImage(
          source: ImageSource.camera,
          maxHeight: 800.0,
          maxWidth: 700.0
        );
      else{
        auxFile = await _picker.getImage(
          source: ImageSource.gallery,
          maxHeight: 800.0,
          maxWidth: 700.0
        );
      }
      print(auxFile.path);
        
      var objetoArchivo = _documentos.firstWhere((archivo) => archivo.tipoDocumento == tipo);    
      setState(() {objetoArchivo.documento = auxFile.path;});
    }catch(e){
      print('### Error _getImage ###');
    }
  }

  showImage(tipo){
    String pathFile = _documentos.singleWhere((archivo) => archivo.tipoDocumento == tipo).documento;
    
    if(pathFile != null){
      String titulo = _catDocumentos.singleWhere((archivo) => archivo.tipo == tipo).descDocumento;
      return Container(
        width: 100.0,
        child: ContainerShadow(
          child: Hero(
            tag: "image"+tipo.toString(),
            child: GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageDetail(tipo: tipo,image: File(pathFile), titulo: titulo))),
              child: Image.file(File(pathFile))
            ),
          )
        ),
      );
    }else
      return Container(
        width: 100.0,
        child: ContainerShadow(
          child: Image.asset(Constants.notImage) 
        ),
      );
      //return Container(
      //  color: Colors.grey[200],
      //  margin: EdgeInsets.only(bottom: 5.0),
      //  padding: EdgeInsets.all(1.0),
      //  child: Image.asset(Constants.notImage)
      //);
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
                  1,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                );
              }
              widget.backPage();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 10.0, color: Colors.blue),
                Text('Dirección'.toUpperCase(), style: TextStyle(color: Colors.blue)),
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

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

