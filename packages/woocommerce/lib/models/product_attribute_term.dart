import 'utils/string.dart';

class WooProductAttributeTerm {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final int? menuOrder;
  final int? count;
  final WooProductAttributeTermLinks? links;

  const WooProductAttributeTerm(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.menuOrder,
      this.count,
      this.links});

  factory WooProductAttributeTerm.fromJson(Map<String, dynamic> json) {
    return WooProductAttributeTerm(
      id: json['id'],
      name: StringUtils.htmlUnescape(json['name']),
      slug: json['slug'],
      description: json['description'],
      menuOrder: json['menu_order'],
      count: json['count'],
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
    data['description'] = this.description;
    data['menu_order'] = this.menuOrder;
    data['count'] = this.count;
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

  @override
  toString() => this.toJson().toString();
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
