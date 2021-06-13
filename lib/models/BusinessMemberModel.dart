class BusinessMemberModel {
  final int member_id;
  final bool is_owner;
  final String industry;
  final String company_brief;
  final String business_type;
  final String deal_details;
  final String deal_value;
  final String name;

  BusinessMemberModel(
      {this.member_id,
      this.is_owner,
      this.industry,
      this.company_brief,
      this.business_type,
      this.deal_details,
      this.deal_value,
      this.name});

  factory BusinessMemberModel.fromJson(Map<String, dynamic> json) {
    return BusinessMemberModel(
      member_id: json['member_id'],
      is_owner: json['is_owner'],
      industry: json['industry'],
      company_brief: json['company_brief'],
      business_type: json['business_type'],
      deal_details: json['deal_details'],
      deal_value: json['deal_value'],
      name: json['name'],
    );
  }
}
