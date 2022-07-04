import 'note.dart';

class Notes {
  List<Note>? values;

  Notes([this.values]);

  List<Note> get _v => values ?? [];

  // region List getters

  int get length => _v.length;

  bool get isEmpty => _v.isEmpty;

  bool get isNotEmpty => _v.isNotEmpty;

  // endregion

  // region Filters

  Map<int, Note> get byCourse => {for (Note n in _v) n.courseid ?? -1: n};

  List<Note> get recent {
    final recent = _v.where((n) => n.isRecent).toList();
    recent.sort((n1, n2) => n1.created!.compareTo(n2.created!));
    return recent.reversed.toList();
  }

  List<Note> get important => _v.where((n) => n.isImportant).toList();

  List<Note> get done => _v.where((n) => n.isDone).toList();

  List<Note> get other =>
      _v.where((n) => n.isNotDone && n.isNotImportant).toList();

  // endregion

  void replace({List<Note>? fromValues, Notes? fromNotes}) {
    if (fromValues == null && fromNotes == null) return;
    values ??= [];
    values!.clear();
    if (fromValues != null) {
      values!.addAll(fromValues);
    } else {
      values!.addAll(fromNotes?.values ?? []);
    }
  }

  @override
  String toString() => values.toString();
}