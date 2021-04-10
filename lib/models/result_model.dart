class Result{
  int resultCode;
  String resultDesc;

  Result({
    this.resultCode,
    this.resultDesc
  });

  Result.jsonMap(Map<String, dynamic> json){
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
  }
}