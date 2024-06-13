import 'package:fast_app_base/data/memory/vo/todo_status.dart';

class Todo{

  Todo({
    required this.id,
    required this.title,
    required this.dueDate,
    this.status = TodoStatus.incomplete,
}): createdTime = DateTime.now();
  // createdTime은 생성자가 호출되는 시점에 만들어지면 된다.


  int id;
  String title;
  final DateTime createdTime;
  DateTime? modifyTime;
  DateTime dueDate;
  TodoStatus status;
}