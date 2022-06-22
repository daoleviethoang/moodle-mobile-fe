import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/firebase/firestore/notes/notes_service.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class NoteEditDialog extends StatefulWidget {
  final int uid;
  final int? courseId;
  final Note? note;

  const NoteEditDialog({
    Key? key,
    required this.uid,
    required this.courseId,
    this.note,
  }) : super(key: key);

  @override
  _NoteEditDialogState createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<NoteEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _uid;
  late int? _courseId;
  late Widget _titleInput;
  late Widget _contentInput;

  late Note _note;
  var _failed = false;
  var _canceling = false;

  bool get _noteInvalid =>
      (_note.title ?? '').isEmpty && (_note.content ?? '').isEmpty;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    _uid = widget.uid;
    _courseId = widget.courseId;
    _note = widget.note ??
        Note(
          id: '${_uid}_${now.millisecondsSinceEpoch}',
          courseId: _courseId,
          title: '',
          content: '',
        );
  }

  _initTitleInput() {
    _titleInput = TextFormField(
      keyboardType: TextInputType.text,
      initialValue: _note.title,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.title,
        labelText: AppLocalizations.of(context)!.title,
        contentPadding: const EdgeInsets.all(Dimens.default_padding_double),
        isDense: true,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius))),
      ),
      maxLines: 1,
      autofocus: widget.note == null,
      onChanged: (value) =>
          setState(() => _note = _note.copyWith(title: value)),
    );
  }

  _initContentInput() {
    _contentInput = TextFormField(
      keyboardType: TextInputType.multiline,
      initialValue: _note.content,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.content,
        labelText: AppLocalizations.of(context)!.content,
        contentPadding: const EdgeInsets.all(Dimens.default_padding_double),
        isDense: true,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius))),
      ),
      minLines: 4,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      onChanged: (value) =>
          setState(() => _note = _note.copyWith(content: value)),
    );
  }

  _submitPressed() async {
    // Start submitting
    if (_noteInvalid) {
      setState(() => _failed = true);
      return;
    }

    // Call API
    final note = await NotesService.setNote(_note);
    // Hide the keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, note);
  }

  _cancelPressed() {
    if (_note.isEmpty) {
      _cancelConfirmPressed();
      return;
    }
    if (widget.note == _note) {
      _cancelConfirmPressed();
      return;
    }
    setState(() => _canceling = true);
    Timer.run(() async {
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _canceling = false);
    });
  }

  _cancelConfirmPressed() {
    // Hide the keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _initTitleInput();
    _initContentInput();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 20),
                  Text(
                    (widget.note == null)
                        ? AppLocalizations.of(context)!.add_note
                        : AppLocalizations.of(context)!.edit_note,
                    style: MoodleStyles.bottomSheetTitleStyle,
                  ),
                  Container(height: 40),
                  _titleInput,
                  Container(height: 20),
                  _contentInput,
                  Container(height: 20),
                  Row(
                    children: [
                      Container(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.note_is_important,
                          textAlign: TextAlign.start,
                          style: MoodleStyles.bottomSheetHeaderStyle,
                        ),
                      ),
                      Switch(
                        value: _note.isImportant,
                        onChanged: (value) =>
                            setState(() => _note.copyWith(isImportant: value)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        opacity: _failed ? 1 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: AnimatedSlide(
                          offset: _failed ? Offset.zero : const Offset(.02, 0),
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            AppLocalizations.of(context)!.err_note_invalid,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomButtonWidget(
                    onPressed: () => _submitPressed(),
                    textButton: (widget.note == null)
                        ? AppLocalizations.of(context)!.add
                        : AppLocalizations.of(context)!.save,
                  ),
                  Container(height: 20),
                  Stack(
                    children: [
                      CustomButtonWidget(
                        onPressed: () => _cancelPressed(),
                        textButton: AppLocalizations.of(context)!.cancel,
                        filled: false,
                      ),
                      Visibility(
                        visible: _canceling,
                        child: CustomButtonWidget(
                          onPressed: () => _cancelConfirmPressed(),
                          textButton:
                              AppLocalizations.of(context)!.cancel_confirm,
                          filled: true,
                          useWarningColor: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: Dimens.default_padding_double),
            Container(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}