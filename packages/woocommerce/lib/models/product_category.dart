import 'package:woocommerce/models/utils/string.dart';

class WooProductCategory {
  final int? id;
  final String? name;
  final String? slug;
  final int? parent;
  final String? description;
  final String? display;
  final WooProductCategoryImage? image;
  final int? menuOrder;
  final int? count;
  final WooProductCategoryLinks? links;

  const WooProductCategory({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.description,
    this.display,
    this.image,
    this.menuOrder,
    this.count,
    this.links,
  });

  factory WooProductCategory.fromJson(Map<String, dynamic> json) {
    return WooProductCategory(
      id: json['id'],
      name: StringUtils.htmlUnescape(json['name']),
      slug: json['slug'],
      parent: json['parent'],
      description: StringUtils.htmlUnescape(json['description']),
      display: json['display'],
      image: json['image'] != null
          ? new WooProductCategoryImage.fromJson(json['image'])
          : null,
      menuOrder: json['menu_order'],
      count: json['count'],
      links: json['_links'] != null
          ? new WooProductCategoryLinks.fromJson(json['_links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['parent'] = this.parent;
    data['description'] = this.description;
    data['display'] = this.display;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
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

class WooProductCategoryImage {
  final int? id;
  final String? dateCreated;
  final String? dateCreatedGmt;
  final String? dateModified;
  final String? dateModifiedGmt;
  final String? src;
  final String? name;
  final String? alt;

  const WooProductCategoryImage(
      {this.id,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateModified,
      this.dateModifiedGmt,
      this.src,
      this.name,
      this.alt});

  factory WooProductCategoryImage.fromJson(Map<String, dynamic> json) {
    return WooProductCategoryImage(
      id: json['id'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      src: (json['src'] != null && json['src'] is String) ? json['src'] : "",
      name: StringUtils.htmlUnescape(json['name']),
      alt: json['alt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    return data;
  }
}

class WooProductCategoryLinks {
  List<WooProductCategorySelf>? self;
  List<WooProductCategoryCollection>? collection;

  WooProductCategoryLinks({this.self, this.collection});

  WooProductCategoryLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <WooProductCategorySelf>[];
      json['self'].forEach((v) {
        self!.add(new WooProductCategorySelf.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <WooProductCategoryCollection>[];
      json['collection'].forEach((v) {
        collection!.add(new WooProductCategoryCollection.fromJson(v));
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

class WooProductCategorySelf {
  String? href;

  WooProductCategorySelf({this.href});

  WooProductCategorySelf.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class WooProductCategoryCollection {
  String? href;

  WooProductCategoryCollection({this.href});

  WooProductCategoryCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
