class SiteInfo {
  List<Functions>? functions;

  SiteInfo({
    this.functions,
  });

  SiteInfo.fromJson(Map<String, dynamic> json) {
    if (json['functions'] != null) {
      functions = [];
      json['functions'].forEach((v) {
        functions!.add(Functions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (functions != null) {
      data['functions'] = functions!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['version'] = version;
    return data;
  }
}