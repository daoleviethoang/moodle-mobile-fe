import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'last_updated_data.g.dart';

@JsonSerializable()
class LastUpdateData {
  Map<int, String>? _messages;
  List<int>? _events;
  List<int>? _notifications;

  LastUpdateData({
    Map<int, String>? messages,
    List<int>? events,
    List<int>? notifications,
  })  : _messages = messages,
        _events = events,
        _notifications = notifications;

  Map<int, String> get messages => _messages ?? {};

  List<int> get events => _events ?? [];

  List<int> get notifications => _notifications ?? [];

  set messages(Map<int, String> value) => _messages = value;

  set events(List<int> value) => _events = value;

  set notifications(List<int> value) => _notifications = value;

  Map<int, String> addMessage(int id, String messageContent) {
    _messages ??= {};
    _messages?.addAll({id: messageContent});
    return messages;
  }

  List<int> addEvent(int id) {
    _events ??= [];
    _events?.add(id);
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