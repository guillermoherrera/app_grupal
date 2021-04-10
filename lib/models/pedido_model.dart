class Pedido{
  String cveCli;
  int noCda;
  String ticket;

  Pedido({
    this.cveCli,
    this.noCda,
    this.ticket
  });

  Map<String, dynamic> toJson() =>{
    'cveCli': cveCli,
    'noCda': noCda,
    'ticket': ticket,
  };
}