import 'utils/string.dart';

class WPIPaymentMethod {
  final String? id;
  final String? title;
  final String? methodTitle;
  final String? description;
  final Map<String, dynamic>? extraData;

  const WPIPaymentMethod({
    this.id,
    this.title,
    this.methodTitle,
    this.description,
    this.extraData,
  });

  WPIPaymentMethod copyWith({
    String? id,
    String? title,
    String? methodTitle,
    String? description,
    Map<String, dynamic>? extraData,
  }) {
    return WPIPaymentMethod(
      id: id ?? this.id,
      title: title ?? this.title,
      methodTitle: methodTitle ?? this.methodTitle,
      description: description ?? this.description,
      extraData: extraData ?? this.extraData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'method_title': methodTitle,
      'description': description,
      'extra_data': extraData,
    };
  }

  factory WPIPaymentMethod.fromMap(Map<String, dynamic> map) {
    return WPIPaymentMethod(
      id: ModelUtils.createStringProperty(map['id']),
      title: ModelUtils.createStringProperty(map['title']),
      methodTitle: ModelUtils.createStringProperty(map['method_title']),
      description: ModelUtils.createStringProperty(map['description']),
      extraData: ModelUtils.createMapOfType<String, dynamic>(map['extra_data']),
    );
  }
}

class WooPaymentGateway {
  final String? id;
  final String? title;
  final String? description;
  final int? order;
  final bool? enabled;
  final String? methodTitle;
  final String? methodDescription;
  final List<String>? methodSupports;
  final WooPaymentGatewaySettings? settings;
  final WooPaymentGatewayLinks? links;

  const WooPaymentGateway({
    required String this.id,
    this.title,
    this.description,
    this.order,
    this.enabled,
    this.methodTitle,
    this.methodDescription,
    this.methodSupports,
    this.settings,
    this.links,
  });

  factory WooPaymentGateway.fromJson(Map<String, dynamic> json) {
    return WooPaymentGateway(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      order: int.tryParse(json['order'].toString()) ?? 0,
      enabled: json['enabled'],
      methodTitle: json['method_title'],
      methodDescription: json['method_description'],
      methodSupports: json['method_supports'].cast<String>(),
      settings: json['settings'] != null
          ? new WooPaymentGatewaySettings.fromJson(json['settings'])
          : null,
      links: json['_links'] != null
          ? new WooPaymentGatewayLinks.fromJson(json['_links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['order'] = this.order;
    data['enabled'] = this.enabled;
    data['method_title'] = this.methodTitle;
    data['method_description'] = this.methodDescription;
    data['method_supports'] = this.methodSupports;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    return data;
  }
}

class WooPaymentGatewaySettings {
  WooPaymentGatewayTitle? title;
  WooPaymentGatewayTitle? instructions;

  WooPaymentGatewaySettings({this.title, this.instructions});

  WooPaymentGatewaySettings.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null
        ? new WooPaymentGatewayTitle.fromJson(json['title'])
        : null;
    instructions = json['instructions'] != null
        ? new WooPaymentGatewayTitle.fromJson(json['instructions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.toJson();
    }
    return data;
  }
}

class WooPaymentGatewayTitle {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? defaultvalue;
  String? tip;
  String? placeholder;

  WooPaymentGatewayTitle(
      {this.id,
      this.label,
      this.description,
      this.type,
      this.value,
      this.defaultvalue,
      this.tip,
      this.placeholder});

  WooPaymentGatewayTitle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    description = json['description'];
    type = json['type'];
    value = json['value'];
    defaultvalue = json['default'];
    tip = json['tip'];
    placeholder = json['placeholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['description'] = this.description;
    data['type'] = this.type;
    data['value'] = this.value;
    data['default'] = this.defaultvalue;
    data['tip'] = this.tip;
    data['placeholder'] = this.placeholder;
    return data;
  }
}

class WooPaymentGatewayLinks {
  List<WooPaymentGatewaySelf>? self;
  List<WooPaymentGatewayCollection>? collection;

  WooPaymentGatewayLinks({this.self, this.collection});

  WooPaymentGatewayLinks.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <WooPaymentGatewaySelf>[];
      json['self'].forEach((v) {
        self!.add(new WooPaymentGatewaySelf.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <WooPaymentGatewayCollection>[];
      json['collection'].forEach((v) {
        collection!.add(new WooPaymentGatewayCollection.fromJson(v));
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

class WooPaymentGatewaySelf {
  String? href;

  WooPaymentGatewaySelf({this.href});

  WooPaymentGatewaySelf.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class WooPaymentGatewayCollection {
  String? href;

  WooPaymentGatewayCollection({this.href});

  WooPaymentGatewayCollection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
