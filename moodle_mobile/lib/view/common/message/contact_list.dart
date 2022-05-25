import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_message.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/participant.dart';
import 'package:moodle_mobile/view/common/slidable_tile.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late ConversationStore _conversationStore;
  late UserStore _userStore;
  late ContactOfMessage _contactOfMessage;

  @override
  void initState() {
    super.initState();

    _conversationStore = GetIt.instance<ConversationStore>();
    _contactOfMessage = GetIt.instance<ContactOfMessage>();
    _userStore = GetIt.instance<UserStore>();

    _conversationStore.getListConversation(
        _userStore.user.token, _userStore.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getContactUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<ConversationMemberModel> listContact = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16),
                ...List.generate(
                  listContact.length,
                  (index) {
                    return ParticipantListTile(
                        fullname: listContact[index].fullname, index: index);
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Future getContactUser() {
    return _contactOfMessage.getUserContact(
        _userStore.user.token, _userStore.user.id);
  }
}
