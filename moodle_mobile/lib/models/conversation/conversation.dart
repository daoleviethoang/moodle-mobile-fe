import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';

class ConversationModel {
  int id;
  int memberCount;
  bool isMuted;
  bool isRead;
  List<ConversationMemberModel> members;
  ConversationMessageModel? message;

  ConversationModel({
    required this.id,
    required this.memberCount,
    required this.isMuted,
    required this.members,
    required this.isRead,
    required this.message,
  });
}
