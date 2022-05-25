class ConversationMemberModel {
  int id;
  String fullname;
  String? profileImageURL;
  bool? isOnline;
  bool? isBlocked;
  bool? showOnLineStatus;

  ConversationMemberModel(
      {required this.id,
      required this.fullname,
      this.profileImageURL,
      this.isOnline,
      this.isBlocked,
      this.showOnLineStatus});
}
