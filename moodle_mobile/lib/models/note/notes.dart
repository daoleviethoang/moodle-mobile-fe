import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/constants/vars.dart';

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
    final recent = _v.where((n) {
      return DateTime.now().difference(n.creationDate) < Vars.recentThreshold;
    }).toList();
    recent.sort((n1, n2) => n1.id.compareTo(n2.id));
    return recent.reversed.toList();
  }

  List<Note> get important => _v.where((n) => n.isImportant).toList();

  List<Note> get done => _v.where((n) => n.isDone).toList();

  List<Note> get personal => _v.where((n) => n.isPersonal).toList();

  // endregion

  void replace(List<Note> newValues) {
    values ??= [];
    values!.clear();
    values!.addAll(newValues);
  }

  @override
  String toString() {
    return values.toString();
  }
}