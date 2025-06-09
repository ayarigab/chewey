import 'utils/string.dart';

class WooTaxClass {
  String? slug;
  String? name;
  WooTaxClassLinks? links;

  WooTaxClass({this.slug, this.name, this.links});

  WooTaxClass.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = StringUtils.htmlUnescape(json['name']);
    links = json['_links'] != null
        ? WooTaxClassLinks.fromJson(json['_links'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slug'] = slug;
    data['name'] = name;
    if (links != null) {
      data['_links'] = links!.toJson();
    }
    return data;
  }

  @override
  toString() => toJson().toString();
}

class WooTaxClassLinks {
  List<WooTaxClassCollection>? collection;

  WooTaxClassLinks({this.collection});

  WooTaxClassLinks.fromJson(Map<String, dynamic> json) {
    if (json['collection'] != null) {
      collection = <WooTaxClassCollection>[];
      json['collection'].forEach((v) {
        collection!.add(WooTaxClassCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (collection != null) {
      data['collection'] = collection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WooTaxClassCollection {
  String? href;

  WooTaxClassCollection({this.href});

  WooTaxClassCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}
