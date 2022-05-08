class Wsfunction {
  Wsfunction._();

  static const String GET_USERS_COURSES = "core_enrol_get_users_courses";
  static const String GET_ENROLLED_USERS = "core_enrol_get_enrolled_users";
  static const String GET_COURSE_BY_FIELD = "core_course_get_courses_by_field";

  //user
  static const String GET_COURSE_GET_CATEGORIES = "core_course_get_categories";

  //course category
  static const String CORE_USER_GET_USERS_BY_FIELD =
      "core_user_get_users_by_field";

  //assignment
  static const String MOD_ASSIGNMENT_SAVE_SUBMISSION =
      "mod_assign_save_submission";
  static const String MOD_ASSIGN_GET_ASSIGNMENTS = "mod_assign_get_assignments";
  static const String MOD_ASSIGN_GET_SUBMISSION_STATUS =
      "mod_assign_get_submission_status";

  //forum
  static const String MOD_FORUM_GET_FORUMS_BY_COURSES =
      "mod_forum_get_forums_by_courses";
  static const String MOD_FORUM_ADD_DISCUSSION = "mod_forum_add_discussion";
  static const String MOD_FORUM_ADD_DISCUSSION_POST =
      "mod_forum_add_discussion_post";

  // message
  static const String CORE_MESSAGE_SEND_MESSAGES_TO_CONVERSATION =
      "core_message_send_messages_to_conversation";
  static const String CORE_MESSAGE_GET_CONVERSATION_MESSAGES =
      "core_message_get_conversation_messages";
  static const String CORE_MESSAGE_DELETE_CONVERSATION_BY_ID =
      "core_message_delete_conversations_by_id";
  static const String CORE_MESSAGE_UNMUTE_CONVERSATIONS =
      "core_message_unmute_conversations";
  static const String CORE_MESSAGE_MUTE_CONVERSATIONS =
      "core_message_mute_conversations";
  static const String CORE_MESSAGE_GET_CONVERSATIONS =
      "core_message_get_conversations";
}