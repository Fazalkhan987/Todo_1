class Todolist{
  final String title;
  bool isCompleted;

  Todolist({
    required this.title,
    this.isCompleted = false,
  });
}

List<Todolist> todoList = [
];