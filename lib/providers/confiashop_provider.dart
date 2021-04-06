import 'package:app_grupal/models/ticket_confiashop_model.dart';
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
    }
    return ticketConfiaShop;
  }

}