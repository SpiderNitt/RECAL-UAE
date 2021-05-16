class EventDetailsInfo {
  String detail_message;
  String registration_link;
  String detail_amendment_message;
  String volunteer_message;

  EventDetailsInfo({
    this.detail_message,
    this.registration_link,
    this.detail_amendment_message,
    this.volunteer_message,
  });

  factory EventDetailsInfo.fromJson(Map<String, dynamic> json) {
    return EventDetailsInfo(
      detail_message: json['detail_message'],
      registration_link: json['registration_link'],
      detail_amendment_message: json['detail_amendment_message'],
      volunteer_message: json['volunteer_message'],
    );
  }
}
