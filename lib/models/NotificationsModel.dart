class NotificationsModel {
  final int status_id;
  final int notification_id;
  final String title;
  bool is_read;
  final String created_at;
  NotificationsModel({this.status_id, this.notification_id, this.title, this.is_read, this.created_at});
  factory NotificationsModel.fromJson(Map<String, dynamic> json){
    return NotificationsModel(
      status_id: json['status_id'],
      notification_id: json['notification_id'],
      title: json['title'],
      is_read: json['is_read'],
      created_at: json['created_at'],
    );
  }
}