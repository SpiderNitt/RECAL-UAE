class SponsorInfo{
  String contact_person_name;
  int contact_person_id;
  String sponsor_name;
  int brochure;

  SponsorInfo({this.sponsor_name, this.contact_person_id, this.contact_person_name, this.brochure});
  factory SponsorInfo.fromJson(Map<String, dynamic> json) {
    return SponsorInfo(
      sponsor_name:json['sponsor_name'],
      contact_person_id:json['contact_person_id'],
      contact_person_name:json['contact_person_name'],
      brochure:json['brochure'],
    );
  }
}