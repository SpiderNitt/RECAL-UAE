class AccountInfo {
  int account_id;
  double payment_amount;
  String date;
  String payment_type;
  String payment_mode;
  String income_expense;
  String invoice_file;
  int paid_by;
  String paid_user_name;

  AccountInfo(
      {this.account_id,
      this.payment_amount,
      this.date,
      this.payment_type,
      this.payment_mode,
      this.income_expense,
      this.invoice_file,
      this.paid_by,
      this.paid_user_name});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
        account_id: json['account_id'],
        payment_amount: json['payment_amount'],
        date: json['date'],
        payment_type: json['payment_type'],
        payment_mode: json['payment_mode'],
        income_expense: json['income_expense'],
        invoice_file: json['invoice'],
        paid_by: json['paid_by'],
        paid_user_name: json['paid_user_name']);
  }
}
