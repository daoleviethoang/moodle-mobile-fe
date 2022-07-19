import 'package:flutter/material.dart';

class CourseDetailsTab extends StatefulWidget {
  final int currentIndex;
  final int index;
  final Widget? icon;
  final Widget? activeIcon;
  final Widget? text;

  const CourseDetailsTab({
    Key? key,
    required this.currentIndex,
    required this.index,
    this.icon,
    this.activeIcon,
    this.text,
  }) : super(key: key);

  @override
  _CourseDetailsTabState createState() => _CourseDetailsTabState();
}

class _CourseDetailsTabState extends State<CourseDetailsTab> {
  late int _currentIndex;
  late int _index;
  late Widget? _icon;
  late Widget? _activeIcon;
  late Widget? _text;

  _updateValues() {
    _currentIndex = widget.currentIndex;
    _index = widget.index;
    _icon = widget.icon;
    _activeIcon = widget.activeIcon;
    _text = widget.text;

    if (_icon == null && _activeIcon != null) {
      _icon = _activeIcon;
    } else if (_icon != null && _activeIcon == null) {
      _activeIcon = _icon;
    } else if (_icon == null && _activeIcon == null) {
      _icon = Container();
      _activeIcon = Container();
    }
    _text ??= Container();
  }

  @override
  Widget build(BuildContext context) {
    _updateValues();
    final isActive = _currentIndex == _index;
    String tooltip = '';
    if (_text is Text) {
      tooltip = (_text as Text).data ?? '';
    }
    return Tooltip(
      message: tooltip,
      verticalOffset: 30,
      child: Tab(
        child: Row(
          children: [
            // FIXME: icon and activeIcon has a delay before updating.
            // FIXME: if (isActive) _activeIcon! else _icon!,
            if (_icon is! Container)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _activeIcon!,
              ),
            _text!,
          ],
        ),
      ),
    );
  }
}