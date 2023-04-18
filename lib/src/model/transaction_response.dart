import 'dart:convert';

TransactionResponse transactionResponseFromJson(String str) =>
    TransactionResponse.fromJson(json.decode(str));

String transactionResponseToJson(TransactionResponse data) =>
    json.encode(data.toJson());

class TransactionResponse {
  TransactionResponse(
      {this.status,
      this.message,
      this.transactionReference,
      this.paymentReference,
      this.amount,
      this.currency = "NGN",
      this.rawData});

  String? status;
  String? message;
  String? transactionReference;
  String? paymentReference;
  int? amount;
  String? currency;
  dynamic rawData;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        status: json["status"],
        message: json["message"],
        transactionReference: json["transactionReference"],
        paymentReference: json["paymentReference"],
        amount: json["authorizedAmount"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "transactionReference": transactionReference,
        "paymentReference": paymentReference,
        "amount": amount,
        "currency": currency
      };
}
