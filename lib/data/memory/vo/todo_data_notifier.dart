import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:flutter/cupertino.dart';

class TodoDataNotifier extends ValueNotifier<List<Todo>>{

  TodoDataNotifier(): super([]);

  void addTodo(Todo todo){
    value.add(todo);
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }
}

/// 상태관리를 위해 지운다.