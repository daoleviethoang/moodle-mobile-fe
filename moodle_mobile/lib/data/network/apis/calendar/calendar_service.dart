import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/calendar/calendar.dart';
import 'package:moodle_mobile/models/calendar/day.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/calendar/week.dart';

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

      final calendar = Calendar.fromJson(json);
      return calendar;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, List<Event>>> getEventsByMonth(
      String token, DateTime date) async {
    final calendar = await getCalendarByMonth(token, date);
    final events = <String, List<Event>>{};
    for (Week w in calendar.weeks ?? []) {
      for (Day d in w.days ?? []) {
        final epoch = (d.timestamp ?? 0) * 1000;
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(epoch);
        var key = DateFormat.yMd().format(dt);
        var visibleEvents =
            (d.events ?? []).where((e) => (e.visible ?? 0) != 0);
        events[key] ??= [];
        events[key]!.addAll(visibleEvents);
      }
    }
    return events;
  }

  Future<List<Event>> getUpcomingByCourse(String token, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_UPCOMING,
        'moodlewsrestformat': 'json',
        'courseid': courseId,
      });

      var json = res.data as Map<String, dynamic>;

      final events = <Event>[];
      for (Map<String, dynamic> e in json['events']) {
        events.add(Event.fromJson(e));
      }
      return events;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<Event> createEvent(String token, Event event) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CREATE_EVENTS,
        'moodlewsrestformat': 'json',
        'events': [
          {
            'name': event.name,
            'description': event.description,
            //'userid': event.userid,
            'eventtype': event.eventtype,
            'format': event.format,
            'timestart': event.timestart,
            'timeduration': event.timeduration,
          }
        ],
      });
      if (kDebugMode) print(res);

      return event;
    } catch (e) {
      rethrow;
    }
  }

  Future<Event> updateEvent(String token, Event event) async =>
      throw 'Unimplemented';

  Future<Event> setEvent(String token, Event event) async {
    try {
      if (kDebugMode) print(event.id);
      if (event.id == -1) {
        return await createEvent(token, event);
      } else {
        return await updateEvent(token, event);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteEvent(String token, int eid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.DELETE_EVENTS,
        'moodlewsrestformat': 'json',
        'events': [
          {'eventid': eid, 'repeat': 0}
        ],
      });
      if (kDebugMode) print(res);
      return true;
    } catch (e) {
      return false;
    }
  }
}