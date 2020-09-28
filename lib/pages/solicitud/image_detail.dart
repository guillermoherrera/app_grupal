import 'dart:io';
import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  ImageDetail({this.tipo, this.image, this.titulo});
  final int tipo;
  final File image;
  final String titulo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(titulo, style: TextStyle(color: Colors.white))
      ),
      body: Center(
        child: Hero(
          tag: "image"+tipo.toString(),
          child: InteractiveViewer(
            child: Image.file(image)
          )//
        )
      ),
    );
  }
}