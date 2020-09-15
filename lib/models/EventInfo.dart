class EventInfo{
  int event_id;
  String event_type;
  String location;
  String event_name;
  String datetime;
  String emirate;
  String event_description;
  String flyer_file_id;
  String reminder_file_id;

  EventInfo({
    this.event_id,
    this.event_type,
    this.location,
    this.datetime,
    this.emirate,
    this.flyer_file_id,
    this.event_name,
    this.event_description,
    this.reminder_file_id});
  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
        event_id:json['event_id'],
        event_type:json['event_type'],
        event_name:json['event_name'],
        location:json['location'],
        datetime:json['datetime'],
        emirate:json['emirate'],
        event_description: json['event_description'],
        flyer_file_id:json['flyer_file_id'],
        reminder_file_id:json['reminder_file_id']
    );
  }
}