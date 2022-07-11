import 'note.dart';
import "package:collection/collection.dart";

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

  /// Get all notes, important on top, sorted by latest.
  List<Note> get all {
    final important = this.important;
    final notImportant = _v.where((n) => n.isNotImportant).toList();
    important.sort((a, b) => a.created?.compareTo(b.created ?? -1) ?? -1);
    notImportant.sort((a, b) => a.created?.compareTo(b.created ?? -1) ?? -1);
    return important.reversed.toList() + notImportant.reversed.toList();
  }

  /// Get all notes, grouped by course id, important on top, sorted by latest.
  Map<int?, List<Note>> get byCourse => groupBy(all, (n) => n.courseid);

  /// Filter recent notes, sorted by latest.
  List<Note> get recent {
    final recent = _v.where((n) => n.isRecent).toList();
    recent.sort((n1, n2) => n1.created!.compareTo(n2.created!));
    return recent.reversed.toList();
  }

  /// Filter important notes, sorted by note id.
  List<Note> get important => _v.where((n) => n.isImportant).toList();

  /// Filter notes that are done, sorted by note id.
  List<Note> get done => _v.where((n) => n.isDone).toList();

  /// Filter notes that are not recent and not important, sorted by note id.
  List<Note> get other =>
      _v.where((n) => n.isNotDone && n.isNotImportant).toList();

  // endregion

  Note? getById(int id) => _v.firstWhereOrNull((n) => n.nid == id);

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