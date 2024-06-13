

import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('yyyy년 MM월 dd일').format(this);

  String get formattedTime => DateFormat('HH:mm').format(this);

  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String get relativeDays {
    final diffDays = difference(DateTime.now().onlyDate).inDays;
    final isNegative = diffDays.isNegative;

    final checkCondition = (diffDays, isNegative);
    return switch (checkCondition) {
      (0, _) => _tillToday,  // 차이가 안 남
      (1, _) => _tillTomorrow, // 차이가 하루
      (_, true) => _dayPassed,  // 음수기만 하면 dayPassed를 돌려준다
      _ => _dayLeft  // 위 3가지가 아니면 dayleft다
    };
  }

  DateTime get onlyDate {
    return DateTime(year, month, day);
  }

  String get _dayLeft => 'daysLeft'
      .tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.toString()});

  String get _dayPassed => 'daysPassed'
      .tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.abs().toString()});

  String get _tillToday => 'tillToday'.tr();

  String get _tillTomorrow => 'tillTomorrow'.tr();
}
