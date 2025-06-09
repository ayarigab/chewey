import 'order.dart';
import 'utils/string.dart';

class WooOrderPayload {
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? status;
  String? currency;
  int? customerId;
  String? customerNote;
  int? parentId;
  List<WooOrderPayloadMetaData>? metaData;
  List<WooOrderPayloadFeeLines>? feeLines;
  List<WooOrderPayloadCouponLines>? couponLines;
  WooOrderPayloadBilling? billing;
  WooOrderPayloadShipping? shipping;
  List<WPILineItems>? lineItems;
  List<ShippingLines>? shippingLines;

  WooOrderPayload(
      {this.paymentMethod,
      this.paymentMethodTitle,
      this.setPaid,
      this.status,
      this.currency,
      this.customerId,
      this.customerNote,
      this.parentId,
      this.metaData,
      this.feeLines,
      this.couponLines,
      this.billing,
      this.shipping,
      this.lineItems,
      this.shippingLines});

  WooOrderPayload.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    setPaid = json['set_paid'];
    status = json['status'];
    currency = json['currency'];
    customerId = json['customer_id'];
    customerNote = json['customer_note'];
    parentId = json['parent_id'];
    if (json['meta_data'] != null) {
      metaData = <WooOrderPayloadMetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(new WooOrderPayloadMetaData.fromJson(v));
      });
    }
    if (json['fee_lines'] != null) {
      feeLines = <WooOrderPayloadFeeLines>[];
      json['fee_lines'].forEach((v) {
        feeLines!.add(new WooOrderPayloadFeeLines.fromJson(v));
      });
    }
    if (json['coupon_lines'] != null) {
      couponLines = <WooOrderPayloadCouponLines>[];
      json['coupon_lines'].forEach((v) {
        couponLines!.add(new WooOrderPayloadCouponLines.fromJson(v));
      });
    }
    billing = json['billing'] != null
        ? new WooOrderPayloadBilling.fromJson(json['billing'])
        : null;
    shipping = json['shipping'] != null
        ? new WooOrderPayloadShipping.fromJson(json['shipping'])
        : null;
    if (json['line_items'] != null) {
      lineItems = <WPILineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(new WPILineItems.fromJson(v));
      });
    }
    if (json['shipping_lines'] != null) {
      shippingLines = <ShippingLines>[];
      json['shipping_lines'].forEach((v) {
        shippingLines!.add(new ShippingLines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    data['payment_method_title'] = this.paymentMethodTitle;
    data['set_paid'] = this.setPaid;
    data['status'] = this.status;
    data['currency'] = this.currency;
    data['customer_id'] = this.customerId;
    data['customer_note'] = this.customerNote;
    data['parent_id'] = this.parentId;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    if (this.feeLines != null) {
      data['fee_lines'] = this.feeLines!.map((v) => v.toJson()).toList();
    }
    if (this.couponLines != null) {
      data['coupon_lines'] = this.couponLines!.map((v) => v.toJson()).toList();
    }
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems!.map((v) => v.toJson()).toList();
    }
    if (this.shippingLines != null) {
      data['shipping_lines'] =
          this.shippingLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  toString() => this.toJson().toString();
}

class WooOrderPayloadMetaData {
  String? key;
  String? value;

  WooOrderPayloadMetaData({this.key, this.value});

  WooOrderPayloadMetaData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class WooOrderPayloadFeeLines {
  String? name;
  String? taxClass;
  String? taxStatus;
  String? total;
  List<WooOrderPayloadMetaData>? metaData;

  WooOrderPayloadFeeLines(
      {this.name, this.taxClass, this.taxStatus, this.total, this.metaData});

  WooOrderPayloadFeeLines.fromJson(Map<String, dynamic> json) {
    name = StringUtils.htmlUnescape(json['name']);
    taxClass = json['tax_class'];
    taxStatus = json['tax_status'];
    total = json['total'];
    if (json['meta_data'] != null) {
      metaData = <WooOrderPayloadMetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(new WooOrderPayloadMetaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tax_class'] = this.taxClass;
    data['tax_status'] = this.taxStatus;
    data['total'] = this.total;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WooOrderPayloadCouponLines {
  String? code;
  List<WooOrderPayloadMetaData>? metaData;

  WooOrderPayloadCouponLines({this.code, this.metaData});

  WooOrderPayloadCouponLines.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['meta_data'] != null) {
      metaData = <WooOrderPayloadMetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(new WooOrderPayloadMetaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WooOrderPayloadBilling {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? company;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  WooOrderPayloadBilling(
      {this.firstName,
      this.lastName,
      this.company,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postcode,
      this.country,
      this.email,
      this.phone});

  WooOrderPayloadBilling.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName ?? "";
    data['last_name'] = this.lastName ?? "";
    data['company'] = this.company ?? "";
    data['address_1'] = this.address1 ?? "";
    data['address_2'] = this.address2 ?? "";
    data['city'] = this.city ?? "";
    data['state'] = this.state ?? "";
    data['postcode'] = this.postcode ?? "";
    data['country'] = this.country ?? "";
    if (this.email != null) {
      data['email'] = this.email ?? "";
    }
    if (this.phone != null) {
      data['phone'] = this.phone ?? "";
    }
    return data;
  }
}

class WooOrderPayloadShipping {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? company;

  WooOrderPayloadShipping(
      {this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.company,
      this.postcode,
      this.country});

  WooOrderPayloadShipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName ?? "";
    data['last_name'] = this.lastName ?? "";
    data['company'] = this.company ?? "";
    data['address_1'] = this.address1 ?? "";
    data['address_2'] = this.address2 ?? "";
    data['city'] = this.city ?? "";
    data['state'] = this.state ?? "";
    data['postcode'] = this.postcode ?? "";
    data['country'] = this.country ?? "";
    return data;
  }
}

class WPILineItems {
  int? productId;
  String? name;
  int? variationId;
  String? taxClass;
  String? subtotal;
  String? total;
  int? quantity;
  List<MetaData>? metaData;
  Map<String, dynamic>? cartItemData;

  WPILineItems({
    this.productId,
    this.name,
    this.variationId,
    this.taxClass,
    this.subtotal,
    this.total,
    this.quantity,
    this.metaData,
    this.cartItemData,
  });

  WPILineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = StringUtils.htmlUnescape(json['name']);
    variationId = json['variation_id'];
    taxClass = json['tax_class'];
    subtotal = json['subtotal'];
    total = json['total'];
    quantity = json['quantity'];
    metaData = json['meta_data'] != null && json['meta_data'] is List
        ? (json['meta_data'] as List).map((e) => MetaData.fromJson(e)).toList()
        : const [];
    cartItemData =
        json['cart_item_data'] != null && json['cart_item_data'] is Map
            ? Map.from(json['cart_item_data']).cast<String, dynamic>()
            : const {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    if (this.name != null) {
      data['name'] = this.name;
    }

    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }
    if (this.taxClass != null) {
      data['tax_class'] = this.taxClass;
    }
    if (this.subtotal != null) {
      data['subtotal'] = this.subtotal;
    }
    if (this.total != null) {
      data['total'] = this.total;
    }

    data['quantity'] = this.quantity;

    if (this.metaData != null && this.metaData!.isNotEmpty) {
      final t = [];
      for (final item in metaData!) {
        t.add(item.toJson());
      }
      data['meta_data'] = t;
    } else {
      data['meta_data'] = const [];
    }

    data['cart_item_data'] = cartItemData;
    return data;
  }

  @override
  toString() => this.toJson().toString();
}

class ShippingLines {
  String? instanceId;
  String? methodId;
  String? methodTitle;
  String? total;

  ShippingLines({this.methodId, this.methodTitle, this.total});

  ShippingLines.fromJson(Map<String, dynamic> json) {
    instanceId = json['instance_id'];
    methodId = json['method_id'];
    methodTitle = json['method_title'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method_id'] = this.methodId;
    data['instance_id'] = this.instanceId;
    data['method_title'] = this.methodTitle;
    data['total'] = this.total;
    return data;
  }
}
