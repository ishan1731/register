class Task {
  int? id;
  int userId;
  bool isCompleted;
  String questionsJson; // JSON string of questions (list)

  Task({this.id, required this.userId, this.isCompleted = false, required this.questionsJson});

  Map<String, dynamic> toMap() {
    final m = {
      'userId': userId,
      'isCompleted': isCompleted ? 1 : 0,
      'questionsJson': questionsJson,
    };
    if (id != null) m['id'] = id as Object;
    return m;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      isCompleted: (map['isCompleted'] as int) == 1,
      questionsJson: map['questionsJson'] as String,
    );
  }
}
