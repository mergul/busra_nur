class RecordSSE{
  String key;
  int value;
  RecordSSE({this.key, this.value});
  factory RecordSSE.fromJson(dynamic json) {
    return RecordSSE(key: json["key"], value: json["value"]);
    }
}