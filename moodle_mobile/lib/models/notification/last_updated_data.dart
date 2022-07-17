import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'last_updated_data.g.dart';

@JsonSerializable()
class LastUpdateData {
  Map<int, String>? _messages;
  Map<int, int>? _events;
  List<int>? _notifications;

  LastUpdateData({
    Map<int, String>? messages,
    Map<int, int>? events,
    List<int>? notifications,
  })  : _messages = messages,
        _events = events,
        _notifications = notifications;

  Map<int, String> get messages => _messages ?? {};

  Map<int, int> get events => _events ?? {};

  List<int> get notifications => _notifications ?? [];

  set messages(Map<int, String> value) => _messages = value;

  set events(Map<int, int> value) => _events = value;

  set notifications(List<int> value) => _notifications = value;

  /// Record each From member's new & latest messages
  /// (which will not be notified again)
  Map<int, String> addMessage(int id, String messageContent) {
    _messages ??= {};
    _messages?.addAll({id: messageContent});
    return messages;
  }

  /// Record each event's notify time
  /// (in minutes: 2-day-worth, 1-day-worth, etc.)
  Map<int, int> addEvent(int id, int minutes) {
    _events ??= {};
    _events?.addAll({id: minutes});
    return events;
  }

  List<int> addNotification(int id) {
    _notifications ??= [];
    _notifications?.add(id);
    return notifications;
  }

  factory LastUpdateData.fromJson(Map<String, dynamic> json) =>
      _$LastUpdateDataFromJson(json);

  Map<String, dynamic> toJson() => _$LastUpdateDataToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}