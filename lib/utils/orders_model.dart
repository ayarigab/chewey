class OrderModel {
  final String orderNumber;
  final int orderID;
  final int customerID;
  final String customerNote;
  final Map<String, dynamic> customerBilling;
  final Map<String, dynamic> customerShipping;
  final int orderParentID;
  final List<Map<String, dynamic>> orderProducts;
  final List<Map<String, dynamic>> orderShipping;
  final double totalAmount;
  final String status;
  final String discountAmt;
  final String shippingAmt;
  final String totalTax;
  final String totalAmt;
  final DateTime date;
  final DateTime dateMod;
  final bool isPaid;

  OrderModel({
    required this.orderNumber,
    required this.orderID,
    required this.customerID,
    required this.customerNote,
    required this.customerBilling,
    required this.customerShipping,
    required this.orderParentID,
    required this.orderProducts,
    required this.orderShipping,
    required this.totalAmount,
    required this.status,
    required this.discountAmt,
    required this.shippingAmt,
    required this.totalTax,
    required this.totalAmt,
    required this.date,
    required this.dateMod,
    required this.isPaid,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderNumber: json['number'],
      orderID: json['id'],
      customerID: json['customer_id'],
      customerNote: json['customer_note'],
      customerBilling: json['billing'],
      customerShipping: json['shipping'],
      orderParentID: json['parent_id'],
      orderProducts: List<Map<String, dynamic>>.from(json['line_items']),
      orderShipping: List<Map<String, dynamic>>.from(json['shipping_lines']),
      totalAmount: double.parse(json['total']),
      status: json['status'],
      discountAmt: json['discount_total'],
      shippingAmt: json['shipping_total'],
      totalTax: json['total_tax'],
      totalAmt: json['total'],
      date: DateTime.parse(json['date_created']),
      dateMod: DateTime.parse(json['date_modified']),
      isPaid: json['date_paid'] != null,
    );
  }
}
