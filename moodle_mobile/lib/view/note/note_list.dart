import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {


  @override
  Widget build(BuildContext context) {
    return Container();
    // return FutureBuilder(
    //     future: queryData(),
    //     builder: (context, data) {
    //       if (data.hasError) {
    //         if (kDebugMode) {
    //           print('${data.error}');
    //         }
    //         return ErrorCard(
    //             text: AppLocalizations.of(context)!.err_get_calendar);
    //       }
    //       return RefreshIndicator(
    //         onRefresh: () async => setState(() => _events.clear()),
    //         child: SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.all(12),
    //             child: Column(
    //               children: [
    //                 Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     AnimatedOpacity(
    //                       opacity: (_events.isEmpty) ? .5 : 1,
    //                       duration: const Duration(milliseconds: 300),
    //                       child: IgnorePointer(
    //                         ignoring: _events.isEmpty,
    //                         child: _monthView,
    //                       ),
    //                     ),
    //                     AnimatedOpacity(
    //                         opacity: (_events.isEmpty) ? 1 : 0,
    //                         duration: const Duration(milliseconds: 300),
    //                         child: const CircularProgressIndicator.adaptive()),
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(top: 12, left: 12),
    //                     child: _dayView,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}