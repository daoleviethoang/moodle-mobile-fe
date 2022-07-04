import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/models/contant/contant_model.dart';
import 'package:moodle_mobile/models/contant/course_arrange.dart';
import 'package:moodle_mobile/models/contant/course_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (isShow == true) {
                setState(() {
                  isFilter = true;
                });
                widget.onOptionSelected(arrangeTypeSelected, statusTypeSelected,
                    showOnlyStarSelected, isFilter);
              }
              isShow = !isShow;
              _runExpandCheck();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
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
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    statusTypeSelected.value +
                        " | " +
                        arrangeTypeSelected.value,
                    style: const TextStyle(
                        color: MoodleColors.black, fontSize: 16),
                  )),
                  Align(
                    alignment: const Alignment(1, 0),
                    child: Icon(
                      isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: MoodleColors.black,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            axisAlignment: 0.0,
            sizeFactor: animation,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: MoodleColors.gray),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(0, 2))
                  ],
                ),
                child: _buildDropListOptions(context)),
          ),
        ],
      ),
    );
  }

  Container _buildDropListOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(top: 27, bottom: 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.arrange_by,
                  textAlign: TextAlign.left,
                  style: MoodleStyles.courseFilterHeaderStyle,
                ),
              ],
            ),
          ),
          Row(
            children: [
              ...ContantExtension.allCourseArrange
                  .map((item) => _buildFilterByArrangeMenu(item, context))
                  .toList()
            ],
          ),
          const Divider(color: Colors.grey, thickness: 1, indent: 10),
          showOnlyStar(context),
          const Divider(color: Colors.grey, thickness: 1, indent: 10),
          Container(height: 10),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.course_status,
                textAlign: TextAlign.left,
                style: MoodleStyles.courseFilterHeaderStyle,
              ),
            ],
          ),
          ...ContantExtension.allCourseStatus
              .map((item) => _buildFilterByStatusMenu(item, context))
              .toList(),
          cancelAndFilterButton(),
        ]),
      ),
    );
  }

  Widget _buildFilterByStatusMenu(ContantModel item, BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
      children: [
        Row(
          children: [
            const Icon(
              Icons.star,
              color: MoodleColors.yellow_icon,
              size: 24,
            ),
            Container(width: 10),
            Text(AppLocalizations.of(context)!.show_star,
                style: const TextStyle(
                    color: MoodleColors.grey_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                maxLines: 3,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Text(AppLocalizations.of(context)!.clear,
                    style: MoodleStyles.courseFilterButtonTextStyle.copyWith(
                      color: MoodleColors.blue,
                    ),
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
                  isFilter = true;
                });
                setState(() {
                  isShow = !isShow;
                });
                widget.onOptionSelected(arrangeTypeSelected, statusTypeSelected,
                    showOnlyStarSelected, isFilter);
                _runExpandCheck();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 5, bottom: 5),
                child: Text(AppLocalizations.of(context)!.filter,
                    style: MoodleStyles.courseFilterButtonTextStyle.copyWith(
                      color: MoodleColors.white,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              )),
        ],
      ),
    );
  }
}
