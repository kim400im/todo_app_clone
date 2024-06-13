import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_item.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.holder.notifier,
      // todoList에는 notifier의 값이 그대로 들어온다.
      builder: (context, todoList, child) {
        return todoList.isEmpty
            ? '할일을 작성해보세요'.text.size(30).makeCentered()
            : Column(
                children: todoList.map((e) => TodoItem(e)).toList(),
              );
      },
    );
  }
}
