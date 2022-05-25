import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/contant/contant_model.dart';
import 'package:moodle_mobile/models/contant/course_arrange.dart';
import 'package:moodle_mobile/models/contant/course_status.dart';

class SelectCourseFilter extends StatefulWidget {
  ContantModel arrangeType;
  ContantModel statusType;
  bool showOnlyStarSelected;
  bool isFilter;
  final Function(ContantModel arrangeType, ContantModel statusType,
      bool showOnlyStarSelected, bool isFilter) onOptionSelected;

  SelectCourseFilter(this.arrangeType, this.statusType,
      this.showOnlyStarSelected, this.isFilter, this.onOptionSelected,
      {Key? key})
      : super(key: key);

  @override
  _SelectCourseFilterState createState() => _SelectCourseFilterState(
      arrangeType, statusType, showOnlyStarSelected, isFilter);
}

class _SelectCourseFilterState extends State<SelectCourseFilter>
    with SingleTickerProviderStateMixin {
  ContantModel arrangeTypeSelected;
  ContantModel statusTypeSelected;
  bool showOnlyStarSelected = false;
  bool isFilter;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;
  bool isClear = false;

  _SelectCourseFilterState(this.arrangeTypeSelected, this.statusTypeSelected,
      this.showOnlyStarSelected, this.isFilter);

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
    return GestureDetector(
      onTap: () {
        isShow = !isShow;
        _runExpandCheck();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: new BoxDecoration(
                border: Border.all(color: MoodleColors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 2))
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
                      child: Text(
                    statusTypeSelected.value +
                        " | " +
                        arrangeTypeSelected.value,
                    style: TextStyle(color: MoodleColors.black, fontSize: 16),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
      ),
    );
  }

  Container _buildDropListOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22, right: 22),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(top: 27, bottom: 8),
          child: Row(
            children: const <Widget>[
              Text(
                'Arrange by',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: MoodleColors.black,
                ),
              ),
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
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1)),
          ),
        ),
        showOnlyStar(context),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1)),
          ),
        ),
        Container(
          child: Row(
            children: const <Widget>[
              Text(
                'Course status',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: MoodleColors.black,
                ),
              ),
            ],
          ),
        ),
        ...ContantExtension.allCourseStatus
            .map((item) => _buildFilterByStatusMenu(item, context))
            .toList(),
        cancelAndFilterButton(),
      ]),
    );
  }

  Widget _buildFilterByStatusMenu(ContantModel item, BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item.value,
              style: const TextStyle(
                  color: MoodleColors.grey_text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              maxLines: 3,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            Radio(
              value: item.key,
              groupValue: statusTypeSelected.key,
              onChanged: (dynamic e) {
                setState(() {
                  CourseStatus courseStatus = e as CourseStatus;
                  statusTypeSelected =
                      ContantModel(key: courseStatus, value: courseStatus.name);
                });
              },
            ),
          ],
        ));
  }

  Widget _buildFilterByArrangeMenu(ContantModel item, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 14),
      child: Row(
        children: <Widget>[
          Center(
            child: TextButton(
                style: TextButton.styleFrom(
                  primary: MoodleColors.blueDark,
                  onSurface: MoodleColors.blueLight,
                  side: BorderSide(
                      color: arrangeTypeSelected.key == item.key
                          ? MoodleColors.blueDark
                          : MoodleColors.gray,
                      width: 2),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                ),
                onPressed: () => {
                      setState(() {
                        arrangeTypeSelected = item;
                      })
                    },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(item.value,
                      style: const TextStyle(
                          color: MoodleColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                )),
          ),
        ],
      ),
    );
  }

  Widget showOnlyStar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.star,
              color: MoodleColors.yellow_icon,
              size: 24,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Show only star',
                  style: TextStyle(
                      color: MoodleColors.grey_text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        Checkbox(
          value: showOnlyStarSelected,
          onChanged: (e) {
            setState(() {
              if (showOnlyStarSelected) {
                showOnlyStarSelected = false;
              } else {
                showOnlyStarSelected = true;
              }
            });
          },
        ),
      ],
    );
  }

  Widget cancelAndFilterButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(color: MoodleColors.gray, width: 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onPressed: () {
                setState(() {
                  arrangeTypeSelected = ContantExtension.courseArrangeSelected;
                  statusTypeSelected = ContantExtension.courseStatusSelected;
                  showOnlyStarSelected = false;
                });
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
                child: Text('Clear',
                    style: TextStyle(
                        color: MoodleColors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              )),
          TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MoodleColors.blue,
                side: const BorderSide(color: MoodleColors.blue, width: 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onPressed: () {
                setState(() {
                  this.isFilter = true;
                });
                setState(() {
                  this.isShow = !this.isShow;
                });
                widget.onOptionSelected(
                    this.arrangeTypeSelected,
                    this.statusTypeSelected,
                    this.showOnlyStarSelected,
                    this.isFilter);
                _runExpandCheck();
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
                child: Text('Filter',
                    style: TextStyle(
                        color: MoodleColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              )),
        ],
      ),
    );
  }
}
