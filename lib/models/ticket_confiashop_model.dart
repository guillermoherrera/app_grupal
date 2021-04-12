class TicketConfiaShop{
  String idTicket;
  double totalPrecioNeto;
  List<TicketDetalle> tIcketDetalle;

  TicketConfiaShop({
    this.idTicket,
    this.totalPrecioNeto,
    this.tIcketDetalle
  });

  TicketConfiaShop.fromJson(Map<String, dynamic> json){
    this.idTicket = json['id_ticket'];
    this.totalPrecioNeto = json['total_precio_neto'];

    List<TicketDetalle> listItems = List();
    for(var item in json['ticket_detalle']){
      final ticketDetalle = TicketDetalle.fromJson(item);
      listItems.add(ticketDetalle);
    }
    this.tIcketDetalle = listItems;
  }

}

class TicketDetalle{
  String marca;
  String estilo;
  String color;
  String talla;
  String jerarquia01;
  String jerarquia02;
  String jerarquia03;
  String jerarquia04;
  int cantidad;
  double totalPrecioNeto;

  TicketDetalle({
    this.color,
    this.estilo,
    this.marca,
    this.talla,
    this.jerarquia01,
    this.jerarquia02,
    this.jerarquia03,
    this.jerarquia04,
    this.cantidad,
    this.totalPrecioNeto
  });

  TicketDetalle.fromJson(Map<String, dynamic> json){
    this.color           = json['color'];
    this.estilo          = json['estilo'];
    this.marca           = json['marca'];
    this.talla           = json['talla'];
    this.jerarquia01     = json['jerarquia01'];
    this.jerarquia02     = json['jerarquia02'];
    this.jerarquia03     = json['jerarquia03'];
    this.jerarquia04     = json['jerarquia04'];
    this.cantidad        = json['cantidad'];
    this.totalPrecioNeto = json['total_precio_neto'] / 1;
  }
}