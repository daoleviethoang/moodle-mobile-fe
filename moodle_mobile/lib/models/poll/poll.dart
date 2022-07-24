import 'package:json_annotation/json_annotation.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  String? subject;
  String? content;
  List<String>? options;
  Map<String, List<String>>? results;

  Poll({this.subject, this.content, this.options, this.results});

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  Map<String, dynamic> toJson() => _$PollToJson(this);
}
