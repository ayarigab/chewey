class WooCoupon {
  final int? id;
  final String? code;
  final String? amount;
  final String? dateCreated;
  final String? dateCreatedGmt;
  final String? dateModified;
  final String? dateModifiedGmt;
  final String? discountType;
  final String? description;
  final String? dateExpires;
  final String? dateExpiresGmt;
  final int? usageCount;
  final bool? individualUse;
  final List<int>? productIds;
  final List<int>? excludedProductIds;
  final int? usageLimit;
  final int? usageLimitPerUser;
  final int? limitUsageToXItems;
  final bool? freeShipping;
  final List<int>? productCategories;
  final List<int>? excludedProductCategories;
  final bool? excludeSaleItems;
  final String? minimumAmount;
  final String? maximumAmount;
  final List<String>? emailRestrictions;
  final List<String>? usedBy;
  final List<String>? metaData;
  final WooCouponLinks? lLinks;
  final WooCouponType couponType;

  const WooCoupon({
    this.id,
    this.code,
    this.amount,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.discountType,
    this.description,
    this.dateExpires,
    this.dateExpiresGmt,
    this.usageCount,
    this.individualUse,
    this.productIds,
    this.excludedProductIds,
    this.usageLimit,
    this.usageLimitPerUser,
    this.limitUsageToXItems,
    this.freeShipping,
    this.productCategories,
    this.excludedProductCategories,
    this.excludeSaleItems,
    this.minimumAmount,
    this.maximumAmount,
    this.emailRestrictions,
    this.usedBy,
    this.metaData,
    this.lLinks,
    this.couponType = WooCouponType.fixedCartDiscount,
  });

  factory WooCoupon.fromJson(Map<String, dynamic> json) {
    return WooCoupon(
      id: json['id'],
      code: json['code'],
      amount: json['amount'] ?? '0',
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      discountType: json['discount_type'],
      description: json['description'],
      dateExpires: json['date_expires'],
      dateExpiresGmt: json['date_expires_gmt'],
      usageCount: json['usage_count'] ?? 0,
      individualUse: json['individual_use'],
      productIds: json['product_ids']?.cast<int>(),
      excludedProductIds: json['excluded_product_ids']?.cast<int>(),
      usageLimit: json['usage_limit'] ?? 0,
      usageLimitPerUser: json['usage_limit_per_user'],
      limitUsageToXItems: json['limit_usage_to_x_items'],
      freeShipping: json['free_shipping'],
      productCategories: json['product_categories']?.cast<int>(),
      excludedProductCategories:
          json['excluded_product_categories']?.cast<int>(),
      excludeSaleItems: json['exclude_sale_items'],
      minimumAmount: json['minimum_amount'] ?? '0',
      maximumAmount: json['maximum_amount'] ?? '0',
      emailRestrictions: json['email_restrictions']?.cast<String>(),
      usedBy: json['used_by']?.cast<String>(),
      metaData: json['meta_data']?.cast<String>(),
      lLinks: json['_links'] != null
          ? WooCouponLinks.fromJson(json['_links'])
          : null,
      couponType: getCouponType(json['discount_type']),
    );
  }

  static WooCouponType getCouponType(String type) {
    switch (type) {
      case 'fixed_cart':
        return WooCouponType.fixedCartDiscount;
      case 'percent':
        return WooCouponType.percentDiscount;
      case 'fixed_product':
        return WooCouponType.fixedProductDiscount;
      default:
        return WooCouponType.fixedCartDiscount;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['amount'] = amount;
    data['date_created'] = dateCreated;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified'] = dateModified;
    data['date_modified_gmt'] = dateModifiedGmt;
    data['discount_type'] = discountType;
    data['description'] = description;
    data['date_expires'] = dateExpires;
    data['date_expires_gmt'] = dateExpiresGmt;
    data['usage_count'] = usageCount;
    data['individual_use'] = individualUse;
    data['product_ids'] = productIds;
    data['excluded_product_ids'] = excludedProductIds;
    data['usage_limit'] = usageLimit;
    data['usage_limit_per_user'] = usageLimitPerUser;
    data['limit_usage_to_x_items'] = limitUsageToXItems;
    data['free_shipping'] = freeShipping;
    data['product_categories'] = productCategories;
    data['excluded_product_categories'] = excludedProductCategories;
    data['exclude_sale_items'] = excludeSaleItems;
    data['minimum_amount'] = minimumAmount;
    data['maximum_amount'] = maximumAmount;
    data['email_restrictions'] = emailRestrictions;
    data['used_by'] = usedBy;
    data['meta_data'] = metaData;
    if (lLinks != null) {
      data['_links'] = lLinks!.toJson();
    }
    return data;
  }

  @override
  toString() => toJson().toString();
}

class WooCouponLinks {
  List<Self>? self;
  List<Collection>? collection;

  WooCouponLinks({this.self, this.collection});

  WooCouponLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <Collection>[];
      json['collection'].forEach((v) {
        collection!.add(Collection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data['self'] = self!.map((v) => v.toJson()).toList();
    }
    if (collection != null) {
      data['collection'] = collection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}

class CouponMetadata {
  int? id;
  String? key;
  String? value;

  CouponMetadata({this.key, this.value});

  CouponMetadata.fromJSON(dynamic json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "value": value,
    };
  }
}

enum WooCouponType {
  fixedCartDiscount,
  percentDiscount,
  fixedProductDiscount,
  other,
}
