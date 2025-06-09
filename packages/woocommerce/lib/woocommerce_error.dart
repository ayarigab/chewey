/*
    Copyright (c) 2020, RAY OKAAH - MailTo: ray@flutterengineer.com, Twitter: Rayscode
    All rights reserved.
 */

class WooCommerceError implements Exception {
  String? code;
  String? message;
  Data? data;

  WooCommerceError({this.code, this.message, this.data});

  WooCommerceError.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  @override
  String toString() {
    return "WooCommerce API Error!:\ncode: $code\nmessage: $message\nstatus: ${data?.status}";
  }
}

class Data {
  int? _status;

  Data({int? status}) {
    _status = status;
  }

  int? get status => _status;

  Data.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    return data;
  }
}
