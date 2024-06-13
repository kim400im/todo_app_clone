import 'package:after_layout/after_layout.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/scaffold/bottom_dialog_scaffold.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:fast_app_base/screen/main/write/vo_write_to_result.dart';
import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';

/// Dialog로 바꿔주자
/// 플러스 버튼을 눌렀을 떄 다일로그가 뜬다.
/// WriteTodoResult 값을 최종적으로 넘겨줄 것이다.
class WriteTodoDialog extends DialogWidget<WriteTodoResult> {
  final Todo? todoForEdit;

  WriteTodoDialog({this.todoForEdit, super.key});

  @override
  DialogState<WriteTodoDialog> createState() => _WriteTodoDialogState();
}

// flutter pub add after_layout으로 설치하자
// 화면이 열리면 바로 키보드가 등장하도록함. afterFirstLayout 사용
class _WriteTodoDialogState extends DialogState<WriteTodoDialog>
    with AfterLayoutMixin {
  DateTime _selectedDate = DateTime.now();
  final textController = TextEditingController();
  final node = FocusNode(); // 키보드가 보여지고 안 보여지고 처리

  @override
  void initState() {
    if(widget.todoForEdit != null){
      _selectedDate = widget.todoForEdit!.dueDate;  // null이 아님을 강제하기 위해 ! 사용
      textController.text = widget.todoForEdit!.title;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomDialogScaffold(
        body: RoundedContainer(
      color: context.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              '할일을 작생해주세요'.text.size(18).bold.make(),
              spacer,
              _selectedDate.formattedDate.text.make(),
              IconButton(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_month))
            ],
          ),
          height20,
          Row(
            children: [
              Expanded(
                  child: TextField(
                focusNode: node,
                controller: textController,
              )),
              RoundButton(text: isEditMode? '완료':'추가', onTap: () {
                widget.hide(WriteTodoResult(_selectedDate, textController.text));
              }),
            ],
          )
        ],
      ),
    ));
  }

  bool get isEditMode => widget.todoForEdit!=null;

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 10),
      ),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // 화면이 열리면 바로 키보드가 나오게 한다.
    AppKeyboardUtil.show(context, node);
  }
}
