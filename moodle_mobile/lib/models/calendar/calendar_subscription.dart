import 'package:json_annotation/json_annotation.dart';

part 'calendar_subscription.g.dart';

@JsonSerializable()
class CalendarSubscription {
  bool? displayeventsource;

  CalendarSubscription({this.displayeventsource});

  factory CalendarSubscription.fromJson(Map<String, dynamic> json) => _$CalendarSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarSubscriptionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}