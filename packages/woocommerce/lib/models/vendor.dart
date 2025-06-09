class Vendor {
  final int? id;
  final Address? address;
  final String? adminAdditionalFee;
  final String? adminCommission;
  final String? adminCommissionType;
  final String? banner;
  final String? email;
  final bool? enabled;
  final String? firstName;
  final String? gravatar;
  final String? lastName;
  final String? location;
  // final Payment payment;
  final String? phone;
  final Rating? rating;
  final String? registered;
  final String? shopUrl;
  final bool? showEmail;
  final Social? social;
  final String? storeName;
  final bool? trusted;
  final String? vendorAddress;

  const Vendor({
    this.address,
    this.adminAdditionalFee,
    this.adminCommission,
    this.adminCommissionType,
    this.banner,
    this.email,
    this.enabled,
    this.firstName,
    this.gravatar,
    this.id,
    this.lastName,
    this.location,
    // this.payment,
    this.phone,
    this.rating,
    this.registered,
    this.shopUrl,
    this.showEmail,
    this.social,
    this.storeName,
    this.trusted,
    this.vendorAddress,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : 0,
      address: _VendorUtils.createAddress(json['address']),
      adminAdditionalFee: json['admin_additional_fee']?.toString() ?? '',
      adminCommission: json['admin_commission']?.toString() ?? '',
      adminCommissionType: json['admin_commission_type']?.toString() ?? '',
      banner: json['banner']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      enabled: json['enabled'] ?? true,
      firstName: json['first_name']?.toString() ?? '',
      gravatar: json['gravatar']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      // payment:
      //     json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      phone: json['phone']?.toString() ?? '',
      rating: _VendorUtils.createRating(json['rating']),
      registered: json['registered']?.toString() ?? '',
      shopUrl: json['shop_url']?.toString() ?? '',
      showEmail: json['show_email'] ?? true,
      social: _VendorUtils.createSocial(json['social']),
      storeName: json['store_name']?.toString() ?? '',
      trusted: json['trusted'] ?? true,
      vendorAddress: json['vendor_address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin_additional_fee'] = adminAdditionalFee;
    data['admin_commission'] = adminCommission;
    data['admin_commission_type'] = adminCommissionType;
    data['banner'] = banner;
    data['email'] = email;
    data['enabled'] = enabled;
    data['first_name'] = firstName;
    data['gravatar'] = gravatar;
    data['id'] = id;
    data['last_name'] = lastName;
    data['location'] = location;
    data['phone'] = phone;
    data['registered'] = registered;
    data['shop_url'] = shopUrl;
    data['show_email'] = showEmail;
    data['store_name'] = storeName;
    data['trusted'] = trusted;
    data['vendor_address'] = vendorAddress;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    // if (this.payment != null) {
    //   data['payment'] = this.payment.toJson();
    // }
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    if (social != null) {
      data['social'] = social!.toJson();
    }
    return data;
  }
}

// class Payment {
//   Bank bank;
//   Paypal paypal;
//
//   Payment({this.bank, this.paypal});
//
//   factory Payment.fromJson(Map<String, dynamic> json) {
//     return Payment(
//       bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
//       paypal: json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bank != null) {
//       data['bank'] = this.bank.toJson();
//     }
//     if (this.paypal != null) {
//       data['paypal'] = this.paypal.toJson();
//     }
//     return data;
//   }
// }
//
// class Bank {
//   String acName;
//   String acNumber;
//   String bankAddr;
//   String bankName;
//   String iban;
//   String routingNumber;
//   String swift;
//
//   Bank({
//     this.acName,
//     this.acNumber,
//     this.bankAddr,
//     this.bankName,
//     this.iban,
//     this.routingNumber,
//     this.swift,
//   });
//
//   factory Bank.fromJson(Map<String, dynamic> json) {
//     return Bank(
//       acName: json['ac_name']?.toString(),
//       acNumber: json['ac_number']?.toString(),
//       bankAddr: json['bank_addr']?.toString(),
//       bankName: json['bank_name']?.toString(),
//       iban: json['iban']?.toString(),
//       routingNumber: json['routing_number']?.toString(),
//       swift: json['swift']?.toString(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ac_name'] = this.acName;
//     data['ac_number'] = this.acNumber;
//     data['bank_addr'] = this.bankAddr;
//     data['bank_name'] = this.bankName;
//     data['iban'] = this.iban;
//     data['routing_number'] = this.routingNumber;
//     data['swift'] = this.swift;
//     return data;
//   }
// }

class Paypal {
  String? email;

  Paypal({this.email});

  factory Paypal.fromJson(Map<String, dynamic> json) {
    return Paypal(
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}

class Rating {
  final int? avg;
  final int? count;
  final int? rating;

  const Rating({this.avg, this.count, this.rating});
  const Rating.empty({
    this.avg = 0,
    this.count = 0,
    this.rating = 0,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      avg: json['avg'] != null ? int.tryParse(json['avg'].toString()) : 0,
      count: json['count'] != null ? int.tryParse(json['count'].toString()) : 0,
      rating:
          json['rating'] != null ? int.tryParse(json['rating'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avg'] = avg;
    data['count'] = count;
    data['rating'] = rating;
    return data;
  }
}

class Social {
  final String? fb;
  final String? flickr;
  final String? instagram;
  final String? linkedin;
  final String? pinterest;
  final String? twitter;
  final String? youtube;

  const Social({
    this.fb,
    this.flickr,
    this.instagram,
    this.linkedin,
    this.pinterest,
    this.twitter,
    this.youtube,
  });
  const Social.empty({
    this.fb = '',
    this.flickr = '',
    this.instagram = '',
    this.linkedin = '',
    this.pinterest = '',
    this.twitter = '',
    this.youtube = '',
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      fb: json['fb']?.toString() ?? '',
      flickr: json['flickr']?.toString() ?? '',
      instagram: json['instagram']?.toString() ?? '',
      linkedin: json['linkedin']?.toString() ?? '',
      pinterest: json['pinterest']?.toString() ?? '',
      twitter: json['twitter']?.toString() ?? '',
      youtube: json['youtube']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fb'] = fb;
    data['flickr'] = flickr;
    data['instagram'] = instagram;
    data['linkedin'] = linkedin;
    data['pinterest'] = pinterest;
    data['twitter'] = twitter;
    data['youtube'] = youtube;
    return data;
  }
}

class Address {
  final String? city;
  final String? country;
  final String? state;
  final String? street_1;
  final String? street_2;
  final String? zip;

  const Address({
    this.city,
    this.country,
    this.state,
    this.street_1,
    this.street_2,
    this.zip,
  });

  const Address.empty({
    this.city = '',
    this.country = '',
    this.state = '',
    this.street_1 = '',
    this.street_2 = '',
    this.zip = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      street_1: json['street_1']?.toString(),
      street_2: json['street_2']?.toString(),
      zip: json['zip']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['street_1'] = street_1;
    data['street_2'] = street_2;
    data['zip'] = zip;
    return data;
  }
}

class _VendorUtils {
  static Address createAddress(dynamic json) {
    try {
      if (json != null && json is Map<String, dynamic>) {
        return Address.fromJson(json);
      } else {
        return const Address.empty();
      }
    } catch (e) {
      return const Address.empty();
    }
  }

  static Rating createRating(dynamic json) {
    try {
      if (json != null && json is Map<String, dynamic>) {
        return Rating.fromJson(json);
      } else {
        return const Rating.empty();
      }
    } catch (e) {
      return const Rating.empty();
    }
  }

  static Social createSocial(dynamic json) {
    try {
      if (json != null && json is Map<String, dynamic>) {
        return Social.fromJson(json);
      } else {
        return const Social.empty();
      }
    } catch (e) {
      return const Social.empty();
    }
  }
}
