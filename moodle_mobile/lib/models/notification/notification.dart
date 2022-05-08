class Notification {
  List<NotificationDetail>? notificationDetail;
  int? unreadcount;
  Notification({this.notificationDetail, this.unreadcount});

  Notification.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notificationDetail = <NotificationDetail>[];
      for (var n in json['notifications']) {
        notificationDetail!.add(NotificationDetail.fromJson(n));
      }
    }
    unreadcount = json['unreadcount'];
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
  String? fullmessageformat;
  String? fullmessagehtml;
  String? smallmessage;
  String? contexturl;
  String? contexturlname;
  String? timecreated;
  String? timecreatedpretty;
  int? timeread;
  int? read;
  int? deleted;
  String? iconurl;
  String? component;
  String? eventtype;
  String? customdata;
  NotificationDetail(
      {this.component,
      this.contexturl,
      this.contexturlname,
      this.customdata,
      this.deleted,
      this.eventtype,
      this.fullmessage,
      this.fullmessageformat,
      this.fullmessagehtml,
      this.iconurl,
      this.id,
      this.read,
      this.shortendsubject,
      this.smallmessage,
      this.subject,
      this.text,
      this.timecreated,
      this.timecreatedpretty,
      this.timeread,
      this.useridfrom,
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
    timecreatedpretty = json['timecreatedpretty'];
    timeread = json['timeread'];
    read = json['read'];
    deleted = json['deleted'];
    iconurl = json['iconurl'];
    component = json['component'];
    eventtype = json['eventtype'];
    customdata = json['customdata'];
  }
}
