class CoreCommModel {
  final String president, vice_president, secretary, joint_secretary, treasurer, mentor1, mentor2,
  date, tenure;


  CoreCommModel({this.president,this.vice_president,this.secretary, this.joint_secretary,this.treasurer
  ,this.mentor1,this.mentor2,this.date,this.tenure});
  factory CoreCommModel.fromJson(Map<String, dynamic> json) {
    return CoreCommModel(
      president: json["president"],
      vice_president: json["vice_president"],
      secretary: json["secretary"],
      joint_secretary: json["join_secretary"],
      treasurer: json["treasurer"],
      mentor1: json["mentor1"],
      mentor2: json["mentor2"],
      date: json["date"],
      tenure: json["tenure"],
    );
  }
}