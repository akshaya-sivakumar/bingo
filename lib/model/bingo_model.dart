class BingoModel {
  BingoModel({
    required this.name,
    required this.value,
  });
  late final String name;
  late final String value;
  
  BingoModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['value'] = value;
    return _data;
  }
}