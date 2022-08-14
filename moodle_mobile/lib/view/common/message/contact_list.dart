import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_message.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/participant.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  // late ConversationStore _conversationStore;
  late UserStore _userStore;
  late ContactOfMessage _contactOfMessage;
  late Repository _repository;

  @override
  void initState() {
    super.initState();

    // _conversationStore = GetIt.instance<ConversationStore>();
    _contactOfMessage = GetIt.instance<ContactOfMessage>();
    _userStore = GetIt.instance<UserStore>();
    _repository = GetIt.instance<Repository>();
  }

  Future getContactUser() async => _contactOfMessage.getUserContact(
      _userStore.user.token, _userStore.user.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getContactUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (kDebugMode) {
          print(snapshot.connectionState);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<ConversationMemberModel> listContact = snapshot.data;
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async => getContactUser(),
              child: ListView(
                padding: const EdgeInsets.all(Dimens.default_padding),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(height: Dimens.default_padding),
                  if (listContact.isEmpty)
                    Opacity(
                      opacity: .5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.nothing_yet,
                        ),
                      ),
                    ),
                  ...List.generate(
                    listContact.length,
                    (index) {
                      return ParticipantListTile(
                        fullname: listContact[index].fullname,
                        id: listContact[index].id,
                        userStore: _userStore,
                        repository: _repository,
                        context: context,
                        avatar: listContact[index].profileImageURL.replaceAll(
                                  "pluginfile.php",
                                  "webservice/pluginfile.php",
                                ) +
                            "?token=${_userStore.user.token}",
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}