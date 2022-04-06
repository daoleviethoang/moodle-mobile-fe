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
}
