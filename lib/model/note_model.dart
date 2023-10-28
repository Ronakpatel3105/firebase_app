class NoteModel {
  String? body;
  String? id;
  String? title;


  NoteModel({
    this.body,
    this.id,
    this.title,

  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      body: json['body'],
      id: json['id'],
      title: json['title'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "title": title,
    };
  }}
