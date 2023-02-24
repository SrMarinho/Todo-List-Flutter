class Todo {
  Todo({required this.title, required this.dateTime, required this.description});

  Todo.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      dateTime = DateTime.parse(json['datetime']),
      description = json['description'];

  String title;
  DateTime dateTime;
  String description;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
      'description': description
    };
  }
}