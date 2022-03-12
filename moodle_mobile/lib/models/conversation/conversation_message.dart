class ConversationMessageModel {
  int id;
  int userIdFrom;
  String text;
  int timeCreated;
  ConversationMessageModel(
      {required this.id,
      required this.userIdFrom,
      required this.text,
      required this.timeCreated});
}
