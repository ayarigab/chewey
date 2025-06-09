import 'utils/string.dart';

enum WooProductAddOnPriceType {
  flatFee,
  quantityBased,
  percentageBased,
  undefined,
}

enum WooProductAddOnType {
  multipleChoice,
  checkbox,
  shortText,
  longText,
  fileUpload,
  undefined,
}

enum WooProductAddOnRestrictionType {
  anyText,
  onlyLetters,
  onlyNumbers,
  onlyLettersNumbers,
  email,
  undefined,
}

enum WooProductAddOnDisplayType {
  dropdown,
  radioButton,
  images,
  undefined,
}

class WooProductAddOn {
  final String description;
  final WooProductAddOnDisplayType display;
  final int max;
  final int min;
  final String name;
  final List<WooProductAddOnOption> options;
  final String price;
  final WooProductAddOnPriceType priceType;
  final int required;
  final WooProductAddOnRestrictionType restrictionsType;
  final WooProductAddOnType type;

  const WooProductAddOn({
    this.description = '',
    this.display = WooProductAddOnDisplayType.undefined,
    this.max = 0,
    this.min = 0,
    this.name = '',
    this.options = const [],
    this.price = '',
    this.priceType = WooProductAddOnPriceType.undefined,
    this.required = 0,
    this.restrictionsType = WooProductAddOnRestrictionType.undefined,
    this.type = WooProductAddOnType.undefined,
  });

  factory WooProductAddOn.fromJson(Map<String, dynamic> json) {
    return WooProductAddOn(
      description: ModelUtils.createStringProperty(json['description']),
      display:
          createDisplayType(ModelUtils.createStringProperty(json['display'])),
      max: ModelUtils.createIntProperty(json['max'], 0),
      min: ModelUtils.createIntProperty(json['min'], 0),
      name: ModelUtils.createStringProperty(json['name']),
      options: ModelUtils.createListOfType<WooProductAddOnOption>(
        json['options'],
        (elem) => WooProductAddOnOption.fromJson(elem),
      ),
      price: ModelUtils.createStringProperty(json['price'], '0'),
      priceType:
          createPriceType(ModelUtils.createStringProperty(json['price_type'])),
      required: ModelUtils.createIntProperty(json['required'], 0),
      restrictionsType: createRestrictionType(
          ModelUtils.createStringProperty(json['restrictions_type'])),
      type: createType(ModelUtils.createStringProperty(json['type'])),
    );
  }

  static WooProductAddOnDisplayType createDisplayType(String value) {
    switch (value) {
      case 'select':
        return WooProductAddOnDisplayType.dropdown;
      case 'radiobutton':
        return WooProductAddOnDisplayType.radioButton;
      case 'images':
        return WooProductAddOnDisplayType.images;
      default:
        return WooProductAddOnDisplayType.undefined;
    }
  }

  static WooProductAddOnPriceType createPriceType(String value) {
    switch (value) {
      case 'flat_fee':
        return WooProductAddOnPriceType.flatFee;
      case 'quantity_based':
        return WooProductAddOnPriceType.quantityBased;
      case 'percentage_based':
        return WooProductAddOnPriceType.percentageBased;
      default:
        return WooProductAddOnPriceType.undefined;
    }
  }

  static WooProductAddOnRestrictionType createRestrictionType(String value) {
    switch (value) {
      case 'anyText':
        return WooProductAddOnRestrictionType.anyText;
      case 'only_letters':
        return WooProductAddOnRestrictionType.onlyLetters;
      case 'only_numbers':
        return WooProductAddOnRestrictionType.onlyNumbers;
      case 'only_letters_numbers':
        return WooProductAddOnRestrictionType.onlyLettersNumbers;
      case 'email':
        return WooProductAddOnRestrictionType.email;
      default:
        return WooProductAddOnRestrictionType.undefined;
    }
  }

  static WooProductAddOnType createType(String value) {
    switch (value) {
      case 'multiple_choice':
        return WooProductAddOnType.multipleChoice;
      case 'checkbox':
        return WooProductAddOnType.checkbox;
      case 'custom_text':
        return WooProductAddOnType.shortText;
      case 'custom_textarea':
        return WooProductAddOnType.longText;
      case 'file_upload':
        return WooProductAddOnType.fileUpload;
      default:
        return WooProductAddOnType.undefined;
    }
  }

  static String getFieldTypeString(WooProductAddOnType type) {
    switch (type) {
      case WooProductAddOnType.multipleChoice:
        return 'multiple_choice';
      case WooProductAddOnType.checkbox:
        return 'checkbox';
      case WooProductAddOnType.shortText:
        return 'custom_text';
      case WooProductAddOnType.longText:
        return 'custom_textarea';
      case WooProductAddOnType.fileUpload:
        return 'file_upload';
      default:
        return '';
    }
  }

  String getFieldType() {
    switch (type) {
      case WooProductAddOnType.multipleChoice:
        return 'multiple_choice';
      case WooProductAddOnType.checkbox:
        return 'checkbox';
      case WooProductAddOnType.shortText:
        return 'custom_text';
      case WooProductAddOnType.longText:
        return 'custom_textarea';
      case WooProductAddOnType.fileUpload:
        return 'file_upload';
      default:
        return '';
    }
  }

  static String getPriceTypeString(WooProductAddOnPriceType priceType) {
    switch (priceType) {
      case WooProductAddOnPriceType.flatFee:
        return 'flat_fee';
      case WooProductAddOnPriceType.quantityBased:
        return 'quantity_based';
      case WooProductAddOnPriceType.percentageBased:
        return 'percentage_based';
      default:
        return '';
    }
  }
}

class WooProductAddOnOption {
  final String imageUrl;
  final String label;
  final String price;
  final WooProductAddOnPriceType priceType;

  const WooProductAddOnOption({
    this.imageUrl = '',
    this.label = '',
    this.price = '',
    this.priceType = WooProductAddOnPriceType.undefined,
  });

  factory WooProductAddOnOption.fromJson(Map<String, dynamic> json) {
    return WooProductAddOnOption(
      imageUrl: ModelUtils.createStringProperty(json['image_url']),
      label: ModelUtils.createStringProperty(json['label']),
      price: ModelUtils.createStringProperty(json['price']),
      priceType: WooProductAddOn.createPriceType(
        ModelUtils.createStringProperty(json['price_type']),
      ),
    );
  }

  String renderLabel({required String currency}) {
    String result = label;

    if (priceType == WooProductAddOnPriceType.flatFee ||
        priceType == WooProductAddOnPriceType.quantityBased) {
      result = '$label ( +$currency$price )';
    }

    if (priceType == WooProductAddOnPriceType.percentageBased) {
      result = '$label ( +$price% )';
    }

    return result;
  }
}
