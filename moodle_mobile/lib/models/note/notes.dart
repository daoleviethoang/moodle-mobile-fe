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

  List<Note> get recent {
    final recent = _v.where((n) => n.isRecent).toList();
    recent.sort((n1, n2) => n1.id.compareTo(n2.id));
    return recent.reversed.toList();
  }

  List<Note> get important => _v.where((n) => n.isImportant).toList();

  List<Note> get done => _v.where((n) => n.isDone).toList();

  List<Note> get personal => _v.where((n) => n.isPersonal).toList();

  // endregion

  void replace({List<Note>? fromValues, Notes? fromNotes}) {
    assert(fromValues != null || fromNotes != null);
    values ??= [];
    values!.clear();
    if (fromValues != null) {
      values!.addAll(fromValues);
    } else {
      values!.addAll(fromNotes?.values ?? []);
    }
  }

  @override
  String toString() {
    return values.toString();
  }
}