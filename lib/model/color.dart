class Color {
  int code;
  String name;
  Color(this.code, this.name);
  Color.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'];

  Map<String, dynamic> toJson() => {'code': code, 'name': name};
}
