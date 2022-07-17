import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/shared_reference/constants/preferences.dart';
import 'package:moodle_mobile/models/notification/last_updated_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bg_events.dart';

class BgService {
  static const String logTag = '[BackgroundFetch]';

  static Future<Map<String, dynamic>> get _data async {
    // Get token and username
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(Preferences.auth_token);
    final username = sp.getString(Preferences.username);
    if (token == null || username == null) return {};

    final userApi = UserApi(DioClient(Dio()));
    final userInfo = await userApi.getUserInfo(token, username);
    final lastUpdated = LastUpdateData.fromJson(
        jsonDecode(sp.getString(Preferences.lastUpdated) ?? '{}'));
    if (kDebugMode) print(lastUpdated);
    return {
      'token': token,
      'userid': userInfo.id,
      'lastUpdated': lastUpdated,
    };
  }

  /// Init the service to the device
  static Future<void> initBackgroundService() async {
    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    await _initPlatformState();
    await BackgroundFetch.registerHeadlessTask(_bgHeadlessTask);
  }

  /// The task that auto-call even when app is closed
  static _bgHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    for (int i = 0; i < 15; i += 1) {
      Timer(Duration(minutes: i), () async => await FetchAll().register(i));
    }
    if (isTimeout) {
      _onTimeOut(taskId);
    }
    _onFetch(taskId);
  }

  /// Configure BackgroundFetch & register fetch events to running queue
  static _initPlatformState() async {
    int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 1,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
      _onFetch,
      _onTimeOut,
    );
    if (kDebugMode) print('$logTag configure success: $status');

    // Register 15 tasks for each event (minimum delay for BgFetch is 15m)
    // NOTE: Maximum task for an app is 100
    for (int i = 0; i < 15; i += 1) {
      Timer(Duration(minutes: i), () async => await FetchAll().register(i));
    }
  }

  /// Run something when a signal (taskId) is received
  static _onFetch(String taskId) async {
    // Abort if data not valid
    final data = await _data;
    if (data['token'] == null || data['userid'] == null) {
      if (kDebugMode) print('$logTag data not valid : $data');
      return;
    }

    // Get event from id
    if (kDebugMode) print("$logTag Event received $taskId");
    BgEvent? ev;
    if (taskId.startsWith('${FetchAll()}')) {
      _onFetch('${FetchMessage()}');
      _onFetch('${FetchNotification()}');
      _onFetch('${FetchCalendar()}');
    } else if (taskId.startsWith('${FetchMessage()}')) {
      ev = FetchMessage();
    } else if (taskId.startsWith('${FetchNotification()}')) {
      ev = FetchNotification();
    } else if (taskId.startsWith('${FetchCalendar()}')) {
      ev = FetchCalendar();
    } else if (taskId == 'flutter_background_fetch') {
      // Event called from adb
      _onFetch('${FetchAll()}');
    }

    // Launch event
    if (ev != null) {
      try {
        final result = await ev.onData(data);
        if (ev.onDone != null) ev.onDone!();
        if (result != null) {
          final sp = await SharedPreferences.getInstance();
          await sp.setString(Preferences.lastUpdated, '$result');
        }
      } catch (e) {
        if (kDebugMode) print("$logTag $taskId error: $e");
        if (ev.onError != null) ev.onError!(data);
        if (ev.cancelOnError ?? false) BackgroundFetch.stop(taskId);
      }
    }

    // End event
    BackgroundFetch.finish(taskId);
  }

  /// Run something when the event that called timed out
  static _onTimeOut(String taskId) async {
    if (kDebugMode) print("$logTag TASK TIMEOUT taskId: $taskId");
    BackgroundFetch.finish(taskId);
  }
}