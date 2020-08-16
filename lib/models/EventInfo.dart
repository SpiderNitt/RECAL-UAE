class EventInfo{
  int event_id;
  String event_type;
  String location;
  String datetime;
  String emirate_id;
  String flyer_file_id;
  String reminder_file_id;

  EventInfo({
    this.event_id,
    this.event_type,
    this.location,
    this.datetime,
    this.emirate_id,
    this.flyer_file_id,
    this.reminder_file_id});
  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
        event_id:json['event_id'],
        event_type:json['event_type'],
        location:json['location'],
        datetime:json['datetime'],
        emirate_id:json['emirate_id'],
        flyer_file_id:json['flyer_file_id'],
        reminder_file_id:json['reminder_file_id']
    );
  }
}