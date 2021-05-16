class MentorGroupModel {
  final int mentor_group_id;
  final String leader;
  final String industry;
  final String group;

  MentorGroupModel(
      {this.mentor_group_id, this.leader, this.industry, this.group});

  factory MentorGroupModel.fromJson(Map<String, dynamic> json) {
    return MentorGroupModel(
      mentor_group_id: json['mentor_group_id'],
      leader: json['leader'],
      industry: json['industry'],
      group: json['group'],
    );
  }
}
