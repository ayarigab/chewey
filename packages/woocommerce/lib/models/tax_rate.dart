import 'utils/string.dart';

class WooTaxRate {
  int? id;
  String? country;
  String? state;
  String? postcode;
  String? city;
  String? rate;
  String? name;
  int? priority;
  bool? compound;
  bool? shipping;
  int? order;
  String? taxClass;
  WooTaxRateLinks? links;

  WooTaxRate(
      {this.id,
      this.country,
      this.state,
      this.postcode,
      this.city,
      this.rate,
      this.name,
      this.priority,
      this.compound,
      this.shipping,
      this.order,
      this.taxClass,
      this.links});

  WooTaxRate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    state = json['state'];
    postcode = json['postcode'];
    city = json['city'];
    rate = json['rate'];
    name = StringUtils.htmlUnescape(json['name']);
    priority = json['priority'];
    compound = json['compound'];
    shipping = json['shipping'];
    order = json['order'];
    taxClass = json['class'];
    links = json['_links'] != null
        ? WooTaxRateLinks.fromJson(json['_links'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['state'] = state;
    data['postcode'] = postcode;
    data['city'] = city;
    data['rate'] = rate;
    data['name'] = name;
    data['priority'] = priority;
    data['compound'] = compound;
    data['shipping'] = shipping;
    data['order'] = order;
    data['class'] = taxClass;
    if (links != null) {
      data['_links'] = links!.toJson();
    }
    return data;
  }

  @override
  toString() => toJson().toString();
}

class WooTaxRateLinks {
  List<WooTaxRateSelf>? self;
  List<WooTaxRateCollection>? collection;

  WooTaxRateLinks({this.self, this.collection});

  WooTaxRateLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <WooTaxRateSelf>[];
      json['self'].forEach((v) {
        self!.add(WooTaxRateSelf.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <WooTaxRateCollection>[];
      json['collection'].forEach((v) {
        collection!.add(WooTaxRateCollection.fromJson(v));
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

class WooTaxRateSelf {
  String? href;

  WooTaxRateSelf({this.href});

  WooTaxRateSelf.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}

class WooTaxRateCollection {
  String? href;

  WooTaxRateCollection({this.href});

  WooTaxRateCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}
