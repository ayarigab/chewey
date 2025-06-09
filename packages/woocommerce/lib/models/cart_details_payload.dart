import 'order.dart';
import 'order_payload.dart';

class WPICartDetailsPayload {
  final String? paymentMethod;
  final String? paymentMethodTitle;
  final String? couponCode;
  final String? customerNote;
  final String? customerId;
  final Billing? billing;
  final Shipping? shipping;
  final List<WPILineItems>? lineItems;
  final WPIShippingLine? shippingLine;
  final String? currency;

  const WPICartDetailsPayload({
    this.paymentMethod,
    this.paymentMethodTitle,
    this.couponCode,
    this.customerNote,
    this.customerId,
    this.billing,
    this.shipping,
    this.lineItems,
    this.shippingLine,
    this.currency,
  });

  WPICartDetailsPayload copyWith({
    String? paymentMethod,
    String? paymentMethodTitle,
    String? couponCode,
    String? customerNote,
    String? customerId,
    String? currency,
    Billing? billing,
    Shipping? shipping,
    List<WPILineItems>? lineItems,
    WPIShippingLine? shippingLine,
  }) {
    return WPICartDetailsPayload(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
      couponCode: couponCode ?? this.couponCode,
      customerNote: customerNote ?? this.customerNote,
      customerId: customerId ?? this.customerId,
      currency: currency ?? this.currency,
      billing: billing ?? this.billing,
      shipping: shipping ?? this.shipping,
      lineItems: lineItems ?? this.lineItems,
      shippingLine: shippingLine ?? this.shippingLine,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method': this.paymentMethod,
      'payment_method_title': this.paymentMethodTitle,
      'coupon_code': this.couponCode,
      'customer_note': this.customerNote,
      'customer_id': this.customerId,
      'currency': this.currency?.toUpperCase(),
      'billing': this.billing?.toJson() ?? const {},
      'shipping': this.shipping?.toJson() ?? const {},
      'line_items': this.lineItems?.map((v) => v.toJson()).toList() ?? const [],
      'shipping_line': this.shippingLine?.toMap() ?? const {},
    };
  }
}

class WPIShippingLine {
  final String instanceId;
  final String methodId;
  final String methodTitle;

  const WPIShippingLine({
    required this.instanceId,
    required this.methodId,
    required this.methodTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'instance_id': this.instanceId,
      'method_id': this.methodId,
      'method_title': this.methodTitle,
    };
  }
}
