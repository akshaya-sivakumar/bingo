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
    final data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}