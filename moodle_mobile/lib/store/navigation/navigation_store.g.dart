// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NavigationStore on _NavigationStore, Store {
  late final _$calendarJumpShowedAtom =
      Atom(name: '_NavigationStore.calendarJumpShowed', context: context);

  @override
  bool get calendarJumpShowed {
    _$calendarJumpShowedAtom.reportRead();
    return super.calendarJumpShowed;
  }

  @override
  set calendarJumpShowed(bool value) {
    _$calendarJumpShowedAtom.reportWrite(value, super.calendarJumpShowed, () {
      super.calendarJumpShowed = value;
    });
  }

  late final _$noteSearchShowedAtom =
      Atom(name: '_NavigationStore.noteSearchShowed', context: context);

  @override
  bool get noteSearchShowed {
    _$noteSearchShowedAtom.reportRead();
    return super.noteSearchShowed;
  }

  @override
  set noteSearchShowed(bool value) {
    _$noteSearchShowedAtom.reportWrite(value, super.noteSearchShowed, () {
      super.noteSearchShowed = value;
    });
  }

  late final _$noteOpenedAtom =
      Atom(name: '_NavigationStore.noteOpened', context: context);

  @override
  bool get noteOpened {
    _$noteOpenedAtom.reportRead();
    return super.noteOpened;
  }

  @override
  set noteOpened(bool value) {
    _$noteOpenedAtom.reportWrite(value, super.noteOpened, () {
      super.noteOpened = value;
    });
  }

  late final _$_NavigationStoreActionController =
      ActionController(name: '_NavigationStore', context: context);

  @override
  void toggleJumpCalendar() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.toggleJumpCalendar');
    try {
      return super.toggleJumpCalendar();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleNoteSearch() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.toggleNoteSearch');
    try {
      return super.toggleNoteSearch();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openNote() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.openNote');
    try {
      return super.openNote();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeNote() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.closeNote');
    try {
      return super.closeNote();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
calendarJumpShowed: ${calendarJumpShowed},
noteSearchShowed: ${noteSearchShowed},
noteOpened: ${noteOpened}
    ''';
  }
}
