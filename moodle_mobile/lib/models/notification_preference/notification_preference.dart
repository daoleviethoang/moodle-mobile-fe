class NotificationPreference {
  int? userid;
  int? disableall;
  List<Processors>? processors;
  List<Components>? components;

  NotificationPreference(
      {this.userid, this.disableall, this.processors, this.components});

  NotificationPreference.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    disableall = json['disableall'];
    if (json['processors'] != null) {
      processors = [];
      json['processors'].forEach((v) {
        processors!.add(Processors.fromJson(v));
      });
    }
    if (json['components'] != null) {
      components = [];
      json['components'].forEach((v) {
        components!.add(Components.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userid'] = userid;
    data['disableall'] = disableall;
    if (processors != null) {
      data['processors'] = processors!.map((v) => v.toJson()).toList();
    }
    if (components != null) {
      data['components'] = components!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Processors {
  String? displayname;
  String? name;
  bool? hassettings;
  int? contextid;
  int? userconfigured;

  Processors(
      {this.displayname,
      this.name,
      this.hassettings,
      this.contextid,
      this.userconfigured});

  Processors.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    name = json['name'];
    hassettings = json['hassettings'];
    contextid = json['contextid'];
    userconfigured = json['userconfigured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['displayname'] = displayname;
    data['name'] = name;
    data['hassettings'] = this.hassettings;
    data['contextid'] = this.contextid;
    data['userconfigured'] = userconfigured;
    return data;
  }
}

class Components {
  String? displayname;
  List<Notifications>? notifications;

  Components({this.displayname, this.notifications});

  Components.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['displayname'] = displayname;
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? displayname;
  String? preferencekey;
  List<Processors2>? processors;

  Notifications({this.displayname, this.preferencekey, this.processors});

  Notifications.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    preferencekey = json['preferencekey'];
    if (json['processors'] != null) {
      processors = [];
      json['processors'].forEach((v) {
        processors!.add(Processors2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['displayname'] = displayname;
    data['preferencekey'] = preferencekey;
    if (processors != null) {
      data['processors'] = processors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Processors2 {
  String? displayname;
  String? name;
  bool? locked;
  int? userconfigured;
  Loggedin? loggedin;
  Loggedin? loggedoff;
  String? lockedmessage;

  Processors2(
      {this.displayname,
      this.name,
      this.locked,
      this.userconfigured,
      this.loggedin,
      this.loggedoff,
      this.lockedmessage});

  Processors2.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    name = json['name'];
    locked = json['locked'];
    userconfigured = json['userconfigured'];
    loggedin =
        json['loggedin'] != null ? Loggedin.fromJson(json['loggedin']) : null;
    loggedoff =
        json['loggedoff'] != null ? Loggedin.fromJson(json['loggedoff']) : null;
    lockedmessage = json['lockedmessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['displayname'] = displayname;
    data['name'] = name;
    data['locked'] = locked;
    data['userconfigured'] = userconfigured;
    if (loggedin != null) {
      data['loggedin'] = loggedin!.toJson();
    }
    if (loggedoff != null) {
      data['loggedoff'] = loggedoff!.toJson();
    }
    data['lockedmessage'] = lockedmessage;
    return data;
  }
}

class Loggedin {
  String? name;
  String? displayname;
  bool? checked;

  Loggedin({this.name, this.displayname, this.checked});

  Loggedin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayname = json['displayname'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['displayname'] = displayname;
    data['checked'] = checked;
    return data;
  }
}
