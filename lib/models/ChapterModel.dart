class ChapterModel {
  final String mission;
  final String vision;
  final String bank_account;
  final String forgot_pass;
  final String welcome_back;
  final List<dynamic> social_media;

  ChapterModel(
      {this.mission,
      this.vision,
      this.bank_account,
      this.forgot_pass,
      this.welcome_back,
      this.social_media});

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
        mission: json["mission"],
        vision: json["vision"],
        bank_account: json["bank_account"],
        forgot_pass: json["forgot_pass"],
        welcome_back: json["welcome_back"],
        social_media: json["social_media"]);
  }
}
