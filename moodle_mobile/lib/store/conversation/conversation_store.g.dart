// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConversationStore on _ConversationStore, Store {
  final _$listConversationAtom =
      Atom(name: '_ConversationStore.listConversation');

  @override
  ObservableList<ConversationModel> get listConversation {
    _$listConversationAtom.reportRead();
    return super.listConversation;
  }

  @override
  set listConversation(ObservableList<ConversationModel> value) {
    _$listConversationAtom.reportWrite(value, super.listConversation, () {
      super.listConversation = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_ConversationStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$getListConversationAsyncAction =
      AsyncAction('_ConversationStore.getListConversation');

  @override
  Future<dynamic> getListConversation(String token, int userId) {
    return _$getListConversationAsyncAction
        .run(() => super.getListConversation(token, userId));
  }

  final _$muteOneConversationAsyncAction =
      AsyncAction('_ConversationStore.muteOneConversation');

  @override
  Future<dynamic> muteOneConversation(
      String token, int userId, int conversationId) {
    return _$muteOneConversationAsyncAction
        .run(() => super.muteOneConversation(token, userId, conversationId));
  }

  @override
  String toString() {
    return '''
listConversation: ${listConversation},
isLoading: ${isLoading}
    ''';
  }
}
