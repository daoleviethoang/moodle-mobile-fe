import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/contant/contant_model.dart';

class SelectCourseFilter extends StatefulWidget {
  final ContantModel arrangeType;
  final ContantModel statusType;
  final Function(ContantModel arrangeType, ContantModel statusType)
      onOptionSelected;

  SelectCourseFilter(this.arrangeType, this.statusType, this.onOptionSelected);

  @override
  _SelectCourseFilterState createState() =>
      _SelectCourseFilterState(arrangeType, statusType);
}

class _SelectCourseFilterState extends State<SelectCourseFilter>
    with SingleTickerProviderStateMixin {
  ContantModel arrangeTypeSelected;
  ContantModel statusTypeSelected;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  _SelectCourseFilterState(this.arrangeTypeSelected, this.statusTypeSelected);

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: new BoxDecoration(
              border: Border.all(color: MoodleColors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10, color: Colors.black26, offset: Offset(0, 2))
              ],
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    this.isShow = !this.isShow;
                    _runExpandCheck();
                    setState(() {});
                  },
                  child: Text(
                    statusTypeSelected.value +
                        " | " +
                        arrangeTypeSelected.value,
                    style: TextStyle(color: MoodleColors.black, fontSize: 16),
                  ),
                )),
                Align(
                  alignment: Alignment(1, 0),
                  child: Icon(
                    isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: MoodleColors.black,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: MoodleColors.grey),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: _buildDropListOptions(context))),
        ],
      ),
    );
  }

  Column _buildDropListOptions(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(top: 27, left: 22, bottom: 8),
        child: Row(
          children: const <Widget>[
            Text(
              'Arrange by',
              style: TextStyle(
                color: MoodleColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
      Row(
        children: <Widget>[
          ...ContantExtension.allCourseArrange
              .map((item) => _buildFilterByArrangeMenu(item, context))
              .toList()
        ],
      ),
      ...ContantExtension.allCourseStatus
          .map((item) => _buildFilterByStatusMenu(item, context))
          .toList(),
    ]);
  }

  Widget _buildFilterByStatusMenu(ContantModel item, BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 26.0, top: 5.0, bottom: 5.0, right: 26.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 1)),
                ),
                child: Text(item.value,
                    style: TextStyle(
                        color: MoodleColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        onTap: () {
          this.statusTypeSelected = item;
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item, item);
        },
      ),
    );
  }

  Widget _buildFilterByArrangeMenu(ContantModel item, BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 26.0, top: 5.0, bottom: 5.0, right: 26.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 1)),
                ),
                child: Text(item.value,
                    style: TextStyle(
                        color: MoodleColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        onTap: () {
          this.statusTypeSelected = item;
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item, item);
        },
      ),
    );
  }
}
