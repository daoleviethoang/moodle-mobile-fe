import 'package:moodle_mobile/models/assignment/submission.dart';

class AttemptAssignment {
  Submission? submission;
  bool? submissionsenabled;
  bool? locked;
  bool? graded;
  bool? canedit;
  bool? caneditowner;
  bool? cansubmit;
  bool? blindmarking;
  String? gradingstatus;

  AttemptAssignment({
    this.submission,
    this.submissionsenabled,
    this.locked,
    this.graded,
    this.canedit,
    this.caneditowner,
    this.cansubmit,
    this.blindmarking,
    this.gradingstatus,
  });

  AttemptAssignment.fromJson(Map<String, dynamic> json) {
    submission = json['submission'] != null
        ? new Submission.fromJson(json['submission'])
        : null;
    submissionsenabled = json['submissionsenabled'];
    locked = json['locked'];
    graded = json['graded'];
    canedit = json['canedit'];
    caneditowner = json['caneditowner'];
    cansubmit = json['cansubmit'];
    blindmarking = json['blindmarking'];
    gradingstatus = json['gradingstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.submission != null) {
      data['submission'] = this.submission?.toJson() ?? null;
    }
    data['submissionsenabled'] = this.submissionsenabled;
    data['locked'] = this.locked;
    data['graded'] = this.graded;
    data['canedit'] = this.canedit;
    data['caneditowner'] = this.caneditowner;
    data['cansubmit'] = this.cansubmit;
    data['blindmarking'] = this.blindmarking;
    data['gradingstatus'] = this.gradingstatus;
    return data;
  }
}
