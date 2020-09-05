class EventModel {
  final int event_id;
  final String event_name;
  final String event_description;
  final String location;
  final String datetime;
  final String emirate;
  final String event_type;
  EventModel({this.event_id, this.event_name, this.event_description, this.location, this.datetime, this.emirate, this.event_type});
  factory EventModel.fromJson(Map<String, dynamic> json){
    return EventModel(
      event_id: json['event_id'],
      event_name: json['event_name'],
      event_description: json['event_description'],
      location: json['location'],
      datetime: json['datetime'],
      emirate: json['emirate'],
      event_type: json['event_type'],

    );
  }
}