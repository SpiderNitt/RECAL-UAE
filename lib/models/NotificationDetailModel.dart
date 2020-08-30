class NotificationDetailModel {
  final int notification_id;
  final String title;
  final String body;
  final String created_at;
  NotificationDetailModel({this.notification_id, this.title, this.body, this.created_at});
  factory NotificationDetailModel.fromJson(Map<String, dynamic> json){
    return NotificationDetailModel(
      notification_id: json['notification_id'],
      title: json['title'],
      body: json['body'],
      created_at: json['created_at'],
    );
  }
}