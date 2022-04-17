class ConversationMemberModel {
  int id;
  String fullname;
  String profileImageURL;
  bool isOnline;
  bool isBlocked;
  bool showOnLineStatus;

  ConversationMemberModel(
      {required this.id,
      required this.fullname,
      required this.profileImageURL,
      required this.isOnline,
      required this.isBlocked,
      required this.showOnLineStatus});
}
