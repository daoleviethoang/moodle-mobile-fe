class MessagePreference {
  Preferences? preferences;
  int? blocknoncontacts;
  bool? entertosend;

  MessagePreference({
    this.preferences,
    this.blocknoncontacts,
    this.entertosend,
  });

  MessagePreference.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'])
        : null;
    blocknoncontacts = json['blocknoncontacts'];
    entertosend = json['entertosend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences!.toJson();
    }
    data['blocknoncontacts'] = this.blocknoncontacts;
    data['entertosend'] = this.entertosend;
    return data;
  }
}

class Preferences {
  int? userid;
  int? disableall;
  List<Processors>? processors;
  List<Components>? components;

  Preferences({this.userid, this.disableall, this.processors, this.components});

  Preferences.fromJson(Map<String, dynamic> json) {
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
    data['userid'] = this.userid;
    data['disableall'] = this.disableall;
    if (this.processors != null) {
      data['processors'] = this.processors!.map((v) => v.toJson()).toList();
    }
    if (this.components != null) {
      data['components'] = this.components!.map((v) => v.toJson()).toList();
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
    data['displayname'] = this.displayname;
    data['name'] = this.name;
    data['hassettings'] = this.hassettings;
    data['contextid'] = this.contextid;
    data['userconfigured'] = this.userconfigured;
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
    data['displayname'] = this.displayname;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
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
    data['displayname'] = this.displayname;
    data['preferencekey'] = this.preferencekey;
    if (this.processors != null) {
      data['processors'] = this.processors!.map((v) => v.toJson()).toList();
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

  Processors2(
      {this.displayname,
      this.name,
      this.locked,
      this.userconfigured,
      this.loggedin,
      this.loggedoff});

  Processors2.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    name = json['name'];
    locked = json['locked'];
    userconfigured = json['userconfigured'];
    loggedin =
        json['loggedin'] != null ? Loggedin.fromJson(json['loggedin']) : null;
    loggedoff =
        json['loggedoff'] != null ? Loggedin.fromJson(json['loggedoff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['displayname'] = this.displayname;
    data['name'] = this.name;
    data['locked'] = this.locked;
    data['userconfigured'] = this.userconfigured;
    if (this.loggedin != null) {
      data['loggedin'] = this.loggedin!.toJson();
    }
    if (this.loggedoff != null) {
      data['loggedoff'] = this.loggedoff!.toJson();
    }
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
    data['name'] = this.name;
    data['displayname'] = this.displayname;
    data['checked'] = this.checked;
    return data;
  }
}
