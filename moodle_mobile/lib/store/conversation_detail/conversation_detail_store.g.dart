// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConversationDetailStore on _ConversationDetailStore, Store {
  late final _$listMessagesAtom =
      Atom(name: '_ConversationDetailStore.listMessages', context: context);

  @override
  ObservableList<ConversationMessageModel> get listMessages {
    _$listMessagesAtom.reportRead();
    return super.listMessages;
  }

  @override
  set listMessages(ObservableList<ConversationMessageModel> value) {
    _$listMessagesAtom.reportWrite(value, super.listMessages, () {
      super.listMessages = value;
    });
  }

  late final _$getListMessageAsyncAction =
      AsyncAction('_ConversationDetailStore.getListMessage', context: context);

  @override
  Future<dynamic> getListMessage(String token, int userId, int conversationId) {
    return _$getListMessageAsyncAction
        .run(() => super.getListMessage(token, userId, conversationId));
  }

  late final _$sentMessageAsyncAction =
      AsyncAction('_ConversationDetailStore.sentMessage', context: context);

  @override
  Future<dynamic> sentMessage(String token, int conversationId, String text) {
    return _$sentMessageAsyncAction
        .run(() => super.sentMessage(token, conversationId, text));
  }

  @override
  String toString() {
    return '''
listMessages: ${listMessages}
    ''';
  }
}
