import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/search/search_api.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/search_user/message_contact.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/participant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchUser extends SearchDelegate<MessageContact?> {
  final UserStore userStore;
  final Repository repository;
  SearchUser({
    required this.userStore,
    required this.repository,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: MoodleColors.blue),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Future<List<MessageContact>> searchUser() async {
    List<MessageContact> temp = [];
    temp = await SearchApi()
        .searchUser(userStore.user.token, userStore.user.id, query);

    return temp;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchUser(),
      builder: (context, snapshot) {
        if (query == '') {
          return Container(
            color: Colors.white,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.search_user,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            )),
          );
        }
        if (snapshot.error != null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.error_connect),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<MessageContact> contacts = snapshot.data as List<MessageContact>;
          if (contacts.isEmpty) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.empty_data,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: contacts
                    .map(
                      (e) => ParticipantListTile(
                        fullname: e.fullname!,
                        id: e.id!,
                        userStore: userStore,
                        repository: repository,
                        context: context,
                        conversationId: e.conversations!.isNotEmpty
                            ? e.conversations!.first.id
                            : null,
                        avatar: e.profileimageurl!.replaceAll(
                              "pluginfile.php",
                              "webservice/pluginfile.php",
                            ) +
                            "?token=${userStore.user.token}",
                      ),
                    )
                    .toList(),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}