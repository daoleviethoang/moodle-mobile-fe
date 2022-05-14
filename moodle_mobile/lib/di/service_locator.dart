import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/conversation/conversation_api.dart';
import 'package:moodle_mobile/data/network/apis/course/course_participants.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/data/shared_reference/shared_preference_helper.dart';
import 'package:moodle_mobile/di/module/local_module.dart';
import 'package:moodle_mobile/di/module/network_module.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/participants_in_one_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(UserApi(getIt<DioClient>()));
  getIt.registerSingleton(ConversationApi());
  getIt.registerSingleton(CourseParticipants());

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(getIt<UserApi>(), getIt<ConversationApi>(),
      getIt<SharedPreferenceHelper>(), getIt<CourseParticipants>()));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(UserStore(getIt<Repository>()));
  getIt.registerSingleton(ConversationStore(getIt<Repository>()));
}
