import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

class EventEditDialog extends StatefulWidget {
  final String token;
  final int uid;
  final int? cid;
  final Event? event;

  const EventEditDialog({
    Key? key,
    required this.token,
    required this.uid,
    this.cid,
    this.event,
  }) : super(key: key);

  @override
  _EventEditDialogState createState() => _EventEditDialogState();
}

class _EventEditDialogState extends State<EventEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _uid;
  late int _cid;
  late Widget _contentInput;
  late Widget _timeInput;

  late Event _event;
  var _failed = false;
  var _canceling = false;

  bool get _eventInvalid =>
      (_event.timestart ?? 0) < DateTime.now().millisecondsSinceEpoch ~/ 1000;

  DateTime get now {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1,
      0,
    );
  }

  @override
  void initState() {
    super.initState();
    _uid = widget.uid;
    _cid = widget.cid ?? 0;
    _event = widget.event ??
        Event(
          id: -1,
          name: '',
          description: '',
          userid: _uid,
          courseid: _cid,
          eventtype: 'user',
          format: 1,
          descriptionformat: 1,
          timestart: now.millisecondsSinceEpoch ~/ 1000,
          timeduration: 0,
        );
  }

  _initContentInput() {
    _contentInput = Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          initialValue: _event.name,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.name,
            labelText: AppLocalizations.of(context)!.name,
            contentPadding: const EdgeInsets.all(Dimens.default_padding_double),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.default_border_radius))),
          ),
          autofocus: widget.event == null,
          onChanged: (value) => setState(() => _event.name = value),
        ),
        Container(height: 8),
        TextFormField(
          keyboardType: TextInputType.multiline,
          initialValue: _event.description,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.description,
            labelText: AppLocalizations.of(context)!.description,
            contentPadding: const EdgeInsets.all(Dimens.default_padding_double),
            isDense: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.default_border_radius))),
          ),
          minLines: 3,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          onChanged: (value) => setState(() => _event.description = value),
        ),
      ],
    );
  }

  _initTimeInput() {
    final initialTime =
        DateTime.fromMillisecondsSinceEpoch((_event.timestart ?? 0) * 1000);
    print('${initialTime.year}-${initialTime.month}-${initialTime.day}');
    _timeInput = Column(
      children: [
        SizedBox(
          height: 64,
          child: Row(
            children: [
              Container(width: 16),
              Text(
                AppLocalizations.of(context)!.due_time,
                style: MoodleStyles.noteHeaderStyle,
              ),
              Container(width: 32),
              Expanded(
                child: CupertinoDatePicker(
                  key: ValueKey(
                      '${initialTime.year}-${initialTime.month}-${initialTime.day}'),
                  initialDateTime: initialTime,
                  minimumDate: isSameDay(initialTime, now) ? now : null,
                  onDateTimeChanged: (value) => _timeUpdated(
                    hour: value.hour,
                    minute: value.minute,
                  ),
                  minuteInterval: 10,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                ),
              ),
              Container(width: 32),
            ],
          ),
        ),
        Container(height: 16),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            color: CupertinoColors.tertiarySystemFill,
            child: SizedBox(
              height: 280,
              child: CalendarDatePicker(
                initialDate: initialTime,
                firstDate: now,
                lastDate: DateTime(2100),
                onDateChanged: (value) => _timeUpdated(
                  year: value.year,
                  month: value.month,
                  day: value.day,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _timeUpdated({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
  }) {
    final initialTime =
        DateTime.fromMillisecondsSinceEpoch((_event.timestart ?? 0) * 1000);
    year ??= initialTime.year;
    month ??= initialTime.month;
    day ??= initialTime.day;
    hour ??= initialTime.hour;
    minute ??= initialTime.minute;
    var value = DateTime(year, month, day, hour, minute);
    if (value.isBefore(now)) {
      value = DateTime(year, month, day, now.hour, 0);
    }
    setState(() => _event.timestart = value.millisecondsSinceEpoch ~/ 1000);
  }

  _submitPressed() async {
    // Start submitting
    if (_eventInvalid) {
      setState(() => _failed = true);
      return;
    }

    // Call API
    final event = await CalendarService().setEvent(widget.token, _event);
    // Hide the keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, event);
  }

  _cancelPressed() {
    if (_event.isEmpty) {
      _cancelConfirmPressed();
      return;
    }
    if (widget.event == _event) {
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
    _initContentInput();
    _initTimeInput();

    return WillPopScope(
      onWillPop: () => _cancelPressed(),
      child: Form(
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
                      (widget.event == null)
                          ? AppLocalizations.of(context)!.add_event
                          : AppLocalizations.of(context)!.edit_event,
                      style: MoodleStyles.bottomSheetTitleStyle,
                    ),
                    Container(height: 40),
                    _contentInput,
                    Container(height: 20),
                    _timeInput,
                    SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: AnimatedOpacity(
                          opacity: _failed ? 1 : 0,
                          duration: const Duration(milliseconds: 150),
                          child: AnimatedSlide(
                            offset:
                                _failed ? Offset.zero : const Offset(.02, 0),
                            duration: const Duration(milliseconds: 150),
                            child: Text(
                              AppLocalizations.of(context)!.err_event_invalid,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: () => _submitPressed(),
                      textButton: (widget.event == null)
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
      ),
    );
  }
}