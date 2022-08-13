import 'package:mobx/mobx.dart';

part 'navigation_store.g.dart';

class NavigationStore = _NavigationStore with _$NavigationStore;

abstract class _NavigationStore with Store {
  @observable
  bool calendarJumpShowed = false;

  @observable
  bool noteSearchShowed = false;

  @observable
  bool noteOpened = false;

  @observable
  bool eventAddShowed = false;

  @action
  void toggleJumpCalendar() => calendarJumpShowed = !calendarJumpShowed;

  @action
  void toggleNoteSearch() => noteSearchShowed = !noteSearchShowed;

  @action
  void openNote() => noteOpened = true;

  @action
  void closeNote() => noteOpened = false;

  @action
  void toggleEventAdd() => eventAddShowed = !eventAddShowed;
}