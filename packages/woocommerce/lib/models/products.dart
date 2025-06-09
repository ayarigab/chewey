import 'perfect_woocommerce_brands.dart';
import 'product_category.dart';
import 'utils/string.dart';
import 'vendor.dart';
import 'woo_product_add_on.dart';

class WooProduct {
  int? id;
  String? name;
  String? slug;
  String? permalink;
  String? type;
  String? status;
  bool? featured;
  String? catalogVisibility;
  String? description;
  String? shortDescription;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? priceHtml;
  bool? onSale;
  bool? purchasable;
  int? totalSales;
  bool? virtual;
  bool? downloadable;
  List<WooProductDownload>? downloads;
  int? downloadLimit;
  int? downloadExpiry;
  String? externalUrl;
  String? buttonText;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  int? stockQuantity;
  String? stockStatus;
  String? backorders;
  bool? backordersAllowed;
  bool? backordered;
  bool? soldIndividually;
  String? weight;
  WooProductDimension? dimensions;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shippingClass;
  int? shippingClassId;
  bool? reviewsAllowed;
  String? averageRating;
  int? ratingCount;
  List<int>? relatedIds;
  List<int>? upsellIds;
  List<int>? crossSellIds;
  int? parentId;
  String? purchaseNote;
  List<WooProductCategory>? categories;
  List<WooProductItemTag>? tags;
  List<WooProductImage>? images;
  List<WooProductItemAttribute>? attributes;
  List<WooProductDefaultAttribute>? defaultAttributes;
  List<int>? variations;
  List<int>? groupedProducts;
  int? menuOrder;
  List<MetaData>? metaData;

  /// The key should be the country code
  Map<String, WooMultiCurrencyPriceItem>? multiCurrencyPrices;

  /// Support for Perfect WooCommerce Brand Plugin
  List<PerfectWooCommerceBrand>? brands;

  /// Information about the vendor
  Vendor? vendor;

  Map<String, dynamic>? acf;
  List<WooProductAddOn>? productAddOns;

  WooProduct({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.type,
    this.status,
    this.featured,
    this.catalogVisibility,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.priceHtml,
    this.onSale,
    this.purchasable,
    this.totalSales,
    this.virtual,
    this.downloadable,
    this.downloads,
    this.downloadLimit,
    this.downloadExpiry,
    this.externalUrl,
    this.buttonText,
    this.taxStatus,
    this.taxClass,
    this.manageStock,
    this.stockQuantity,
    this.stockStatus,
    this.backorders,
    this.backordersAllowed,
    this.backordered,
    this.soldIndividually,
    this.weight,
    this.dimensions,
    this.shippingRequired,
    this.shippingTaxable,
    this.shippingClass,
    this.shippingClassId,
    this.reviewsAllowed,
    this.averageRating,
    this.ratingCount,
    this.relatedIds,
    this.upsellIds,
    this.crossSellIds,
    this.parentId,
    this.purchaseNote,
    this.categories,
    this.tags,
    this.images,
    this.attributes,
    this.defaultAttributes,
    this.variations,
    this.groupedProducts,
    this.menuOrder,
    this.metaData,
    this.multiCurrencyPrices,
    this.brands,
    this.vendor,
    this.acf,
    this.productAddOns,
  });

  WooProduct.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProduct.empty();
      return;
    }
    id = json['id'];
    name = StringUtils.htmlUnescape(json['name']);
    slug = json['slug'];
    permalink = json['permalink'];
    type = json['type'];
    status = json['status'];
    featured = json['featured'];
    catalogVisibility = json['catalog_visibility'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price']?.toString() ?? '';
    regularPrice = json['regular_price']?.toString() ?? '';
    salePrice = json['sale_price']?.toString() ?? '';
    priceHtml = json['price_html'];
    onSale = json['on_sale'];
    purchasable = json['purchasable'];
    totalSales = json['total_sales'];
    virtual = json['virtual'];
    downloadable = json['downloadable'];
    try {
      downloads = (json['downloads'] as List)
          .map((i) => WooProductDownload.fromJson(i))
          .toList();
    } catch (e) {
      downloads = const [];
    }
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
    externalUrl = json['external_url'];
    buttonText = json['button_text'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    manageStock = json['manage_stock'];
    stockQuantity = json['stock_quantity'] ?? 0;
    stockStatus = json['stock_status'];
    backorders = json['backorders'];
    backordersAllowed = json['backorders_allowed'];
    backordered = json['backordered'];
    soldIndividually = json['sold_individually'] ?? false;
    weight = json['weight'];
    dimensions = WooProductDimension.fromJson(json['dimensions']);
    shippingRequired = json['shipping_required'];
    shippingTaxable = json['shipping_taxable'];
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    reviewsAllowed = json['reviews_allowed'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'] ?? 0;
    relatedIds = json['related_ids']?.cast<int>();
    upsellIds = json['upsell_ids']?.cast<int>();
    crossSellIds = json['cross_sell_ids']?.cast<int>();
    parentId = json['parent_id'];
    purchaseNote = json['purchase_note'];
    try {
      categories = (json['categories'] as List)
          .map((i) => WooProductCategory.fromJson(i))
          .toList();
    } catch (e) {
      categories = const [];
    }
    try {
      tags = (json['tags'] as List)
          .map((i) => WooProductItemTag.fromJson(i))
          .toList();
    } catch (e) {
      tags = const [];
    }
    try {
      images = (json['images'] as List)
          .map((i) => WooProductImage.fromJson(i))
          .toList();
    } catch (e) {
      images = const [];
    }
    try {
      attributes = (json['attributes'] as List)
          .map((i) => WooProductItemAttribute.fromJson(i))
          .toList();
    } catch (e) {
      attributes = const [];
    }
    try {
      defaultAttributes = (json['default_attributes'] as List)
          .map((i) => WooProductDefaultAttribute.fromJson(i))
          .toList();
    } catch (e) {
      defaultAttributes = const [];
    }
    variations = json['variations']?.cast<int>();
    groupedProducts = json['grouped_products']?.cast<int>();
    menuOrder = json['menu_order'];
    try {
      metaData =
          (json['meta_data'] as List).map((i) => MetaData.fromJson(i)).toList();
    } catch (e) {
      metaData = const [];
    }
    try {
      if (json['am_multi_currency_prices'] != null) {
        final temp = Map<String, Map<String, dynamic>>.from(
            json['am_multi_currency_prices']);

        if (temp.isEmpty) {
          multiCurrencyPrices = const {};
        } else {
          temp.forEach((key, value) {
            multiCurrencyPrices ??= {};
            multiCurrencyPrices!.addAll({
              key: WooMultiCurrencyPriceItem.fromJson(value),
            });
          });
        }
      } else {
        multiCurrencyPrices = const {};
      }
    } catch (_) {
      multiCurrencyPrices = const {};
    }
    try {
      if (json['brands'] == null || (json['brands'] as List).isEmpty) {
        brands = const [];
      } else {
        final temp = List<Map<String, dynamic>>.from(json['brands']);
        brands ??= <PerfectWooCommerceBrand>[];
        for (var i = 0; i < temp.length; i++) {
          brands!.add(PerfectWooCommerceBrand.fromMap(temp[i]));
        }
      }
    } catch (_) {
      brands = const [];
    }
    try {
      if (json['store'] != null && json['store'] is Map) {
        vendor = Vendor.fromJson(json['store']);
      }
    } catch (e) {
      vendor = const Vendor();
    }
    try {
      acf = json['acf'];
    } catch (e) {
      acf = const {};
    }
    try {
      productAddOns = ModelUtils.createListOfType(
        json['woostore_pro_product_add_ons'],
        (elem) => WooProductAddOn.fromJson(elem),
      );
    } catch (e) {
      productAddOns = const [];
    }
  }

  WooProduct.empty();

  @override
  String toString() =>
      '{id: $id}, {name: $name}, {price: $price}, {status: $status}';
}

class WooMultiCurrencyPriceItem {
  final String? rate;
  final String? price;
  final String? regularPrice;
  final String? salePrice;

  const WooMultiCurrencyPriceItem({
    this.rate,
    this.price,
    this.regularPrice,
    this.salePrice,
  });

  factory WooMultiCurrencyPriceItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WooMultiCurrencyPriceItem();
    } else {
      return WooMultiCurrencyPriceItem(
        rate: json['rate']?.toString(),
        price: json['price']?.toString(),
        regularPrice: json['regular_price']?.toString(),
        salePrice: json['sale_price']?.toString(),
      );
    }
  }

  @override
  String toString() {
    return 'WooMultiCurrencyPriceItem{rate: $rate, price: $price, regularPrice: $regularPrice, salePrice: $salePrice}';
  }
}

class WooProductItemTag {
  int? id;
  String? name;
  String? slug;

  WooProductItemTag({
    this.id,
    this.name,
    this.slug,
  });

  WooProductItemTag.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductItemTag.empty();
      return;
    }
    id = json['id'];
    name = StringUtils.htmlUnescape(json['name']);
    slug = json['slug'];
  }

  WooProductItemTag.empty();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
      };

  @override
  String toString() => 'Tag: $name';
}

class MetaData {
  int? id;
  String? key;
  String? value;

  MetaData({
    this.id,
    this.key,
    this.value,
  });

  MetaData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      MetaData.empty();
      return;
    }
    id = json['id'];
    key = json['key'];
    value = json['value']?.toString();
  }

  MetaData.empty();

  Map<String, dynamic> toJson() => {'id': id, 'key': key, 'value': value};
}

class WooProductDefaultAttribute {
  int? id;
  String? name;
  String? option;

  WooProductDefaultAttribute({
    this.id,
    this.name,
    this.option,
  });

  WooProductDefaultAttribute.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductDefaultAttribute.empty();
      return;
    }
    id = json['id'];
    name = StringUtils.htmlUnescape(json['name']);
    option = json['option'];
  }

  WooProductDefaultAttribute.empty();

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'option': option};
}

class WooProductImage {
  int? id;
  DateTime? dateCreated;
  DateTime? dateCreatedGMT;
  DateTime? dateModified;
  DateTime? dateModifiedGMT;
  String? src;
  String? name;
  String? alt;

  WooProductImage({
    this.id,
    this.src,
    this.name,
    this.alt,
    this.dateCreated,
    this.dateCreatedGMT,
    this.dateModified,
    this.dateModifiedGMT,
  });

  WooProductImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductImage.empty();
      return;
    }
    id = json['id'];
    src = json['src'];
    name = StringUtils.htmlUnescape(json['name']);
    alt = json['alt'];
    dateCreated = json['date_created'] != null
        ? DateTime.parse(json['date_created'] as String)
        : null;
    dateModifiedGMT = json['date_modified_gmt'] != null
        ? DateTime.parse(json['date_modified_gmt'] as String)
        : null;
    dateModified = json['date_modified'] != null
        ? DateTime.parse(json['date_modified'] as String)
        : null;
    dateCreatedGMT = json['date_created_gmt'] != null
        ? DateTime.parse(json['date_created_gmt'] as String)
        : null;
  }

  WooProductImage.empty();
}

class WooProductDimension {
  String? length;
  String? width;
  String? height;

  WooProductDimension({
    this.length,
    this.height,
    this.width,
  });

  WooProductDimension.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductDimension.empty();
      return;
    }
    length = json['length'];
    width = json['width'];
    height = json['height'];
  }

  WooProductDimension.empty();

  Map<String, dynamic> toJson() =>
      {'length': length, 'width': width, 'height': height};
}

class WooProductItemAttribute {
  int? id;
  String? name;
  int? position;
  bool? visible;
  bool? variation;
  List<String>? options;

  WooProductItemAttribute({
    this.id,
    this.name,
    this.position,
    this.visible,
    this.variation,
    this.options,
  });

  WooProductItemAttribute.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductItemAttribute.empty();
      return;
    }
    id = json['id'];
    name = StringUtils.htmlUnescape(json['name']);
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options']?.cast<String>();
  }

  WooProductItemAttribute.empty();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'position': position,
        'visible': visible,
        'variation': variation,
        'options': options,
      };
}

class WooProductDownload {
  String? id;
  String? name;
  String? file;

  WooProductDownload({
    this.id,
    this.name,
    this.file,
  });

  WooProductDownload.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      WooProductDownload.empty();
      return;
    }
    id = json['id'];
    name = StringUtils.htmlUnescape(json['name']);
    file = json['file'];
  }

  WooProductDownload.empty();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'file': file,
      };
}
