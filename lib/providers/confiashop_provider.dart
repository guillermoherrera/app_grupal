import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/ticket_confiashop_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfiashopProvider{

  String urlBase = 'https://servicios.confiashop.com/api';

  Future<TicketConfiaShop> getArticulosByTicket(String ticket, String usuario)async{
    TicketConfiaShop ticketConfiaShop;
    String breakPoint = '/ConfiaShop_Ticket_Info?id_empresa=1&tipo_usuario=1&id_usuario=$usuario&estatus=${'CAPTURA'}&id_ticket=$ticket';
    try{
      final resp = await http.get(urlBase+breakPoint).timeout(Duration(seconds: 10));
      final decodeData = json.decode(resp.body);
      await Future.delayed(Duration(milliseconds: 1000));
      ticketConfiaShop = TicketConfiaShop.fromJson(decodeData[0]);
    }catch(e){
      print(e);
      Fluttertoast.showToast(
        msg: Constants.errorAuth('$e').toUpperCase(),
        backgroundColor: Colors.red.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 10,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 15
      );
    }
    return ticketConfiaShop;
  }

}