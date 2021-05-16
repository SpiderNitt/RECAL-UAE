class SocialMediaFeed {
  String platform;
  String feed_url;

  SocialMediaFeed({this.platform, this.feed_url});

  factory SocialMediaFeed.fromJson(Map<String, dynamic> json) {
    return SocialMediaFeed(
      platform: json['platform'],
      feed_url: json['feed_url'],
    );
  }
}
