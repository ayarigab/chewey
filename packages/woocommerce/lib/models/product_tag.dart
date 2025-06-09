import 'utils/string.dart';

class WooProductTag {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final int? count;
  final WooProductTagLinks? lLinks;

  const WooProductTag(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.count,
      this.lLinks});

  factory WooProductTag.fromJson(Map<String, dynamic> json) {
    return WooProductTag(
      id: json['id'],
      name: StringUtils.htmlUnescape(json['name']),
      slug: json['slug'],
      description: json['description'],
      count: json['count'],
      lLinks: json['_links'] != null
          ? new WooProductTagLinks.fromJson(json['_links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['count'] = this.count;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    return data;
  }

  @override
  toString() => this.toJson().toString();
}

class WooProductTagLinks {
  List<WooProductTagSelf>? self;
  List<WooProductTagCollection>? collection;

  WooProductTagLinks({this.self, this.collection});

  WooProductTagLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <WooProductTagSelf>[];
      json['self'].forEach((v) {
        self!.add(new WooProductTagSelf.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <WooProductTagCollection>[];
      json['collection'].forEach((v) {
        collection!.add(new WooProductTagCollection.fromJson(v));
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

class WooProductTagSelf {
  String? href;

  WooProductTagSelf({this.href});

  WooProductTagSelf.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class WooProductTagCollection {
  String? href;

  WooProductTagCollection({this.href});

  WooProductTagCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
