import 'utils/string.dart';

class WooProductAttribute {
  final int? id;
  final String? name;
  final String? slug;
  final String? type;
  final String? orderBy;
  final bool? hasArchives;
  final WooProductAttributeTermLinks? links;

  const WooProductAttribute(
      {this.id,
      this.name,
      this.slug,
      this.type,
      this.orderBy,
      this.hasArchives,
      this.links});

  factory WooProductAttribute.fromJson(Map<String, dynamic> json) {
    return WooProductAttribute(
      id: json['id'],
      name: StringUtils.htmlUnescape(json['name']),
      slug: json['slug'],
      type: json['type'],
      orderBy: json['order_by'],
      hasArchives: json['has_archives'],
      links: json['_links'] != null
          ? new WooProductAttributeTermLinks.fromJson(json['_links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['order_by'] = this.orderBy;
    data['has_archives'] = this.hasArchives;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    return data;
  }

  @override
  toString() => this.toJson().toString();
}

class WooProductAttributeTermLinks {
  List<WooProductAttributeTermSelf>? self;
  List<WooProductAttributeTermCollection>? collection;

  WooProductAttributeTermLinks({this.self, this.collection});

  WooProductAttributeTermLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <WooProductAttributeTermSelf>[];
      json['self'].forEach((v) {
        self!.add(new WooProductAttributeTermSelf.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <WooProductAttributeTermCollection>[];
      json['collection'].forEach((v) {
        collection!.add(new WooProductAttributeTermCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WooProductAttributeTermSelf {
  String? href;

  WooProductAttributeTermSelf({this.href});

  WooProductAttributeTermSelf.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class WooProductAttributeTermCollection {
  String? href;

  WooProductAttributeTermCollection({this.href});

  WooProductAttributeTermCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
