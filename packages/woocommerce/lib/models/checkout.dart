import 'package:flutter/cupertino.dart';
import 'package:quiver/strings.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/models/order_payload.dart';

/// WooStore Pro Api shipping method package that needs to be sent to the
/// endpoint [woostore_pro_api/checkout/get-shipping-methods]
class WPIShippingMethodRequestPackage {
  final List<WPILineItems> lineItems;
  final Shipping shipping;
  final Billing billing;
  final String? customerId;

  const WPIShippingMethodRequestPackage({
    required this.lineItems,
    required this.shipping,
    required this.billing,
    this.customerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'customer_id': this.customerId ?? '0',
      'billing': this.billing.toJson(),
      'shipping': this.shipping.toJson(),
      'line_items': this.lineItems.map((v) => v.toJson()).toList(),
    };
  }
}

@immutable
class WPIShippingMethod {
  final String? cost;
  final String? methodId;
  final String? instanceId;
  final String? methodTitle;

  const WPIShippingMethod({
    this.cost,
    this.methodId,
    this.instanceId,
    this.methodTitle,
  });

  const WPIShippingMethod.empty({
    this.cost = '0',
    this.methodId = '0',
    this.instanceId = '0',
    this.methodTitle = '',
  });

  factory WPIShippingMethod.fromJson(Map<String, dynamic> json) {
    String methodId = '';

    if (isNotBlank(json['method_id']?.toString() ?? '')) {
      methodId = json['method_id']?.toString() ?? '';
    }

    String methodTitle = '';
    if (isNotBlank(json['method_title']?.toString() ?? '')) {
      methodTitle = json['method_title']?.toString() ?? '';
    }

    return WPIShippingMethod(
      cost: isNotBlank(json['cost']?.toString() ?? '')
          ? json['cost']?.toString()
          : '0',
      methodId: methodId,
      instanceId:
          json['instance_id'] != null ? json['instance_id']?.toString() : '0',
      methodTitle: methodTitle,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost'] = this.cost;
    data['method_id'] = this.methodId;
    data['instance_id'] = this.instanceId;
    data['method_title'] = this.methodTitle;
    return data;
  }
}
