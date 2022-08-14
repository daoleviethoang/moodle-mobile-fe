import 'dart:convert';

class NotificationPopup {
  List<NotificationDetail>? notificationDetail;
  int? warningcount;
  int? read;
  NotificationPopup({this.notificationDetail, this.warningcount, this.read});

  NotificationPopup.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      notificationDetail = <NotificationDetail>[];
      for (var n in json['messages']) {
        if (n != null) {
          notificationDetail!.add(NotificationDetail.fromJson(n));
        }
      }
    }

    // notificationDetail = json['notifications'];
    //warningcount = json['unreadcount'];
  }
}

class NotificationDetail {
  int? id;
  int? useridfrom;
  int? useridto;
  String? subject;
  String? shortendsubject;
  String? text;
  String? fullmessage;
  int? fullmessageformat;
  String? fullmessagehtml;
  String? smallmessage;
  String? contexturl;
  String? contexturlname;
  int? timecreated;

  int? notifcation;
  int? timeread;
  bool? read;
  String? userToFullName;
  String? userFromFullName;
  bool? deleted;

  CustomData? customdata;
  //String? stringCustomData;
  int? cmid;
  NotificationDetail(
      {this.contexturl,
      this.contexturlname,
      this.customdata,
      this.deleted,
      this.fullmessage,
      this.fullmessageformat,
      this.fullmessagehtml,
      this.id,
      this.read,
      this.shortendsubject,
      this.notifcation,
      this.smallmessage,
      this.subject,
      this.text,
      this.timecreated,
      this.timeread,
      this.useridfrom,
      this.userFromFullName,
      this.userToFullName,
      this.useridto});

  NotificationDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    useridfrom = json['useridfrom'];
    useridto = json['useridto'];
    subject = json['subject'];
    shortendsubject = json['shortendsubject'];
    text = json['text'];
    fullmessage = json['fullmessage'];
    fullmessageformat = json['fullmessageformat'];
    fullmessagehtml = json['fullmessagehtml'];
    smallmessage = json['smallmessage'];
    contexturl = json['contexturl'];
    contexturlname = json['contexturlname'];
    timecreated = json['timecreated'];
    userFromFullName = json['userfromfullname'];
    userToFullName = json['usertofullname'];
    timeread = json['timeread'];
    //read = json['read'];
    deleted = json['deleted'];
    read = false;

    //stringCustomdata = CustomData.fromJson(jsonDecode(json['customdata']));
    if (json['customdata'] != null) {
      customdata = CustomData.fromJson(jsonDecode(json['customdata']));
    }

    // stringCustomData = json['customdata'];
    //cmid = int.tryParse(customdata!.substring(,))
    // print('id ' +
    //     stringCustomData!.substring(
    //         stringCustomData!.lastIndexOf(r'\"courseid\":\"'),
    //         stringCustomData!.lastIndexOf(r'\"}')));
    //print(jsonDecode(json['customdata']));
  }
}

class CustomData {
  String? cmid;
  String? instance;
  String? discussionid;
  String? postid;
  String? notificationiconurl;
  List<String>? actionbuttons;
  int? courseId;
  CustomData(
      {this.actionbuttons,
      this.cmid,
      this.courseId,
      this.discussionid,
      this.instance,
      this.notificationiconurl,
      this.postid});
  CustomData.fromJson(Map<String, dynamic> json) {
    //cmid = checkId(json['cmid']);
    // instance = json['instance'];
    // discussionid = json['discussionid'];
    // postid = json['postid'];
    // notificationiconurl = json['notificationurl'];
    // if (json['actionbuttons'] != null) {
    //   actionbuttons = json['actionbuttons'];
    // }
    //print(json['courseid']);
    //print('error');
    courseId = checkId(json['courseid']);
  }

  int? checkId(value) {
    return int.tryParse(value.toString());
  }
}
