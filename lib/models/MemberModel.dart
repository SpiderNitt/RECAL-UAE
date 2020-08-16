class MemberModel {
  final int user_id;
  final String name;
  final int year_of_graduation;
  final String email;
  final String mobile_no;
  final String organization;
  final String position;
  final String gender;
  final String linkedIn_link;
  MemberModel({this.user_id, this.name, this.year_of_graduation, this.email, this.mobile_no, this.organization, this.position, this.gender, this.linkedIn_link});
  factory MemberModel.fromJson(Map<String, dynamic> json){
    return MemberModel(
    user_id: json['user_id'],
    name: json['name'],
    year_of_graduation: json['year_of_graduation'],
    email: json['email'],
    mobile_no: json['mobile_no'],
    organization: json['organization'],
    position: json['position'],
    gender: json['gender'],
    linkedIn_link: json['linkedIn_link'],

    );
  }
}