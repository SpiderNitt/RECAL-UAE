class SponsorInfo{
String sponsor_name;
int sponsor_id;
int contact_person;
int payment_id;
int brochure_file_id;

SponsorInfo({this.sponsor_name, this.sponsor_id, this.contact_person,
      this.payment_id, this.brochure_file_id});
factory SponsorInfo.fromJson(Map<String, dynamic> json) {
  return SponsorInfo(
      sponsor_name:json['sponsor_name'],
      sponsor_id:json['sponsor_id'],
      contact_person:json['contact_person'],
      payment_id:json['payment_id'],
      brochure_file_id:json['brochure_file_id'],
  );
}
}