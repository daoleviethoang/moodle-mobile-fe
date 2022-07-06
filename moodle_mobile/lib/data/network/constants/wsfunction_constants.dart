class Wsfunction {
  Wsfunction._();

  // course
  static const String GET_USERS_COURSES = "core_enrol_get_users_courses";
  static const String GET_ENROLLED_USERS = "core_enrol_get_enrolled_users";
  static const String GET_COURSE_BY_FIELD = "core_course_get_courses_by_field";
  static const String GET_COURSE_CONTENTS = "core_course_get_contents";
  static const String TRIGGER_VIEW_COURSE = "core_course_view_course";
  static const String SET_FAVOURITE_COURSE =
      "core_course_set_favourite_courses";
  static const String CORE_USER_UPDATE_USER_PREFERENCES =
      "core_user_update_user_preferences";
  static const String GRADEREPORT_COURSE_GRADES =
      "gradereport_overview_get_course_grades";

  // module
  static const String GET_MODULE_BY_ID = "core_course_get_course_module";
  static const String MOD_LTI_GET_TLD = "mod_lti_get_tool_launch_data";

  //user
  static const String GET_COURSE_GET_CATEGORIES = "core_course_get_categories";
  static const String CORE_USER_UPDATE_PRICTURE = "core_user_update_picture";

  // calendar
  static const String GET_CALENDAR_MONTHLY =
      "core_calendar_get_calendar_monthly_view";
  static const String GET_UPCOMING = "core_calendar_get_calendar_upcoming_view";

  // note
  static const String CREATE_NOTES = "core_notes_create_notes";
  static const String DELETE_NOTES = "core_notes_delete_notes";
  static const String GET_COURSE_NOTES = "core_notes_get_course_notes";
  static const String GET_NOTES = "core_notes_get_notes";
  static const String UPDATE_NOTES = "core_notes_update_notes";
  static const String UPDATE_NOTE = "local_modulews_update_note";

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
  static const String MOD_FORUM_GET_FORUM_DISCUSSIONS =
      "mod_forum_get_forum_discussions";
  static const String MOD_FORUM_GET_DISCUSSION_POSTS =
      'mod_forum_get_discussion_posts';
  static const String MOD_FORUM_SET_SUBSCRIPTION =
      'mod_forum_set_subscription_state';

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
  static const String CORE_MESSAGE_GET_CONVERSATION_BETWEEN_USER =
      "core_message_get_conversation_between_users";
  static const String CORE_MESSAGE_SEND_MESSAGE_WITHOUT_CONVERSATIONID =
      "core_message_send_instant_messages";

  //notification
  static const String MESSAGE_POPUP_GET_POPUP_NOTIFICATION =
      'message_popup_get_popup_notifications';

  //notification preference
  static const String CORE_MESSAGE_GET_USER_NOTIFICATION_PREFERENCES =
      "core_message_get_user_notification_preferences";
  static const String CORE_MESSAGE_GET_USER_MESSAGE_PREFERENCES =
      "core_message_get_user_message_preferences";
  static const String CORE_USER_UPDATE_USER_PREFERENCE =
      "core_user_update_user_preferences";

  //enrol
  static const String ENROL_SELF_ENROL_USER = "enrol_self_enrol_user";
  static const String ENROL_GET_COURSE_ENROL_METHODS =
      "core_enrol_get_course_enrolment_methods";

  //search course
  static const String CORE_COURSE_SEARCH_COURSES = "core_course_search_courses";
  static const String CORE_COURSE_SEARCH_USERS =
      "core_message_message_search_users";

  //courses
  static const String CORE_COURSES_PARTICIPANT =
      "core_enrol_get_enrolled_users";
  static const String CORE_USER_CONTACT = "core_message_get_user_contacts";

  //quiz
  static const String MOD_QUIZ_GET_QUIZZES_BY_COURSES =
      "mod_quiz_get_quizzes_by_courses";
  static const String MOD_QUIZ_GET_USER_ATTEMPTS = "mod_quiz_get_user_attempts";
  static const String MOD_QUIZ_START_ATTEMPT = "mod_quiz_start_attempt";
  static const String MOD_QUIZ_PROCESS_ATTEMPT = "mod_quiz_process_attempt";
  static const String MOD_QUIZ_GET_ATTEMPT_DATA = "mod_quiz_get_attempt_data";
  static const String MOD_QUIZ_GET_ATTEMPT_REVIEW =
      "mod_quiz_get_attempt_review";
  static const String MOD_QUIZ_GET_USER_BEST_GRADE =
      "mod_quiz_get_user_best_grade";

  //site info
  static const String CORE_WEBSERVICE_GET_SITE_INFO =
      "core_webservice_get_site_info";

  //custom api
  static const String LOCAL_EDIT_FOLDER_NAME =
      "local_modulews_edit_folder_name_module";
  static const String LOCAL_ADD_SECTION_COURSE =
      "local_modulews_add_section_course";
  static const String LOCAL_EDIT_FOLDER_FILES =
      "local_modulews_edit_folder_files";
  static const String LOCAL_ADD_MODULES = "local_modulews_add_modules";
  static const String LOCAL_REMOVE_FOLDER_MODULE =
      "local_modulews_remove_folder_module_course";
}