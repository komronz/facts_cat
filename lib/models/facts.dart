class Facts{
  final String id;
  final String text;

  Facts({required this.id, required this.text});

  factory Facts.fromJson(Map<String, dynamic> json) {
    String id = json['_id'].toString();
    String text = json['text'].toString();
    return Facts(id: id, text: text);
  }

}