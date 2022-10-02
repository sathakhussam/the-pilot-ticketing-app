class Message {
  String? content;
  String sentAt;
  String by;
  String? filePath;
  bool seen;

  Message({
    required this.content,
    required this.sentAt,
    required this.by,
    required this.seen,
    this.filePath,
  });

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
        content: json['content'],
        sentAt: DateTime.parse(json['sentAt'])
            .toString()
            .split(' ')[1]
            .split(':')
            .sublist(0, 2)
            .join(':'),
        by: json['by'],
        filePath: json['filePath'],
        seen: json['seen'],
      );
}
