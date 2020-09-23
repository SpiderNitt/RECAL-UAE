class SocialMediaModel {
  final int feed_id;
  final String platform;
  final String feed_url;
  SocialMediaModel({this.feed_id, this.feed_url, this.platform});

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
        feed_id: json["feed_id"],
        platform: json["platform"],
        feed_url: json["feed_url"]);
  }
}
