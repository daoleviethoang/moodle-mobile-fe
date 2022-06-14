class SiteInfo {
  List<Functions>? functions;

  SiteInfo({
    this.functions,
  });

  SiteInfo.fromJson(Map<String, dynamic> json) {
    if (json['functions'] != null) {
      functions = [];
      json['functions'].forEach((v) {
        functions!.add(new Functions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.functions != null) {
      data['functions'] = this.functions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Functions {
  String? name;
  String? version;

  Functions({this.name, this.version});

  Functions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['version'] = this.version;
    return data;
  }
}
