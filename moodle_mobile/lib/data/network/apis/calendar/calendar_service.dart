import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/calendar/calendar.dart';

class CalendarService {
  Future<Calendar> getCalendarByMonth(String token, DateTime date) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_CALENDAR_MONTHLY,
        'moodlewsrestformat': 'json',
        'year': date.year,
        'month': date.month,
      });

      var json = res.data as Map<String, dynamic>;

      return Calendar.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<Calendar> getCalendarByRange(String token, DateTime date,
      {int range = 0}) async {
    range = range.abs();
    final calendar = await getCalendarByMonth(token, date);
    calendar.weeks = calendar.weeks ?? [];
    for (var i = 0; i < range; i += 1) {
      final lastMonth = await getCalendarByMonth(
          token, DateTime(date.year, date.month - i + 1, date.day));
      final nextMonth = await getCalendarByMonth(
          token, DateTime(date.year, date.month + i + 1, date.day));
      calendar.weeks!.addAll(lastMonth.weeks ?? []);
      calendar.weeks!.addAll(nextMonth.weeks ?? []);
    }
    return calendar;
  }
}