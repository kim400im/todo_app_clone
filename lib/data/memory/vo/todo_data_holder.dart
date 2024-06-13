import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/data/memory/vo/todo_data_notifier.dart';
import 'package:fast_app_base/data/memory/vo/todo_status.dart';
import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../screen/main/write/d_write_todo.dart';

/// 상태관리를 위해 바꿔보자
/// 기존의 InheritedWidget에서 상태관리를 위해 GetX로 바꾸자
class TodoDataHolder extends InheritedWidget {
  final TodoDataNotifier notifier;
  //final RxList<Todo> todoList = <Todo>[].obs;

  const TodoDataHolder({
    super.key,
    required super.child,
    required this.notifier,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static TodoDataHolder _of(BuildContext context){
    /// dependOnInheritedWidgetOfExactType를 사용하면 같은 위젯 어디에서든지 TodoDataHolder를 찾아서 곧바로 돌려준다.
    TodoDataHolder inherited = (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>())!;
    return inherited;
  }
  /// 위 내용들을 지운다.
  /// RxList로 notifier를 대체했다.

  void changeTodoStatus(Todo todo) async{
    switch(todo.status){
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog('정말로 처음 상태로 변경하시겠어요?').show();
        result?.runIfSuccess((data){
          todo.status = TodoStatus.incomplete;
        });
    }
    notifier.notify();
    //todoList.refresh(); // 이걸로 대체해준다.
    // obs 인 rxlist에 안에서 refresh를 하면 내부적으로 재시작한다.
  }

  void addTodo() async{
    final result = await WriteTodoDialog().show();
    if(result != null){ // mounted는 스크린이 살아있는지 체크
      notifier.addTodo(Todo(
      //todoList.add(Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));
      debugPrint(result.text);
      debugPrint(result.dateTime.formattedDate);
    }
  }

  void editTodo(Todo todo) async{
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if(result != null){
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      notifier.notify();
      //todoList.refresh();
    }
  }

  void removeTodo(Todo todo){
    notifier.value.remove(todo);
    notifier.notify();
    //todoList.remove(todo);
    //todoList.refresh();
  }
}

extension TodoDataHolderContextExtension on BuildContext{
  TodoDataHolder get holder => TodoDataHolder._of(this);
  // holder 와 TodoDataHolder._of 중 하나만 사용하도록 통일할 것이다.
}
