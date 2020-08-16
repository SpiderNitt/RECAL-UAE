class FelicitationModel{
  String achievement;
  String felicitated_person;
  FelicitationModel({this.achievement,this.felicitated_person});
  factory FelicitationModel.fromJson(Map<String, dynamic> json) {
    return FelicitationModel(
        achievement:json['achievement'],
        felicitated_person:json['felicitated_person'],
    );
  }
}