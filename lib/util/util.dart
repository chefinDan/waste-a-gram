import 'dart:async';

import 'package:flutter/cupertino.dart';

String monthString(DateTime dateTime){
  switch (dateTime.month) {
    case DateTime.january: return 'January';
    case DateTime.february: return 'February';
    case DateTime.march: return 'March';
    case DateTime.april: return 'April';
    case DateTime.may: return 'May';
    case DateTime.june: return 'June';
    case DateTime.july: return 'July';
    case DateTime.august: return 'August';
    case DateTime.september: return 'September';
    case DateTime.october: return 'October';
    case DateTime.november: return 'November';
    case DateTime.december: return 'December';
    case DateTime.march: return 'March';
      break;
    default: return '';
  } 
}

String weekdayToString(DateTime dateTime){
  switch (dateTime.weekday) {
    case DateTime.monday: return 'Monday';
    case DateTime.tuesday: return 'Tuesday';
    case DateTime.wednesday: return 'Wednesday';
    case DateTime.thursday: return 'Thursday';
    case DateTime.friday: return 'Friday';
    case DateTime.saturday: return 'Saturday';
    case DateTime.sunday: return 'Sunday';
    default: return '';
  } 
}

Future<T> runSafe<T>(Future<T> Function() func) {
  final onDone = Completer<T>();
  runZoned(
    func,
    onError: (e, s) {
      if (!onDone.isCompleted) {
        onDone.completeError(e, s as StackTrace);
      }
    },
  ).then((result) {
    if (!onDone.isCompleted) {
      onDone.complete(result);
    }
  });
  return onDone.future;
}

const Widget emptyWidget = SizedBox.shrink();
