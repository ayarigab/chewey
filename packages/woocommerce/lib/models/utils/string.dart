// ignore_for_file: depend_on_referenced_packages
import 'package:html_unescape/html_unescape.dart';
import 'package:quiver/strings.dart';

import '../../dev.log.dart';

abstract class StringUtils {
  static String htmlUnescape(String? valueToConvert) {
    if (isBlank(valueToConvert)) {
      return '';
    }
    return HtmlUnescape().convert(valueToConvert!);
  }
}

abstract class ModelUtils {
  static String createStringProperty(dynamic value,
      [String defaultValue = '']) {
    if (value == null) {
      return defaultValue;
    }

    try {
      if (value is String && isNotBlank(value)) {
        return value;
      }

      if (value is! String) {
        return value.toString();
      }
      return defaultValue;
    } catch (e, s) {
      Dev.error('ModelUtils:createStringProperty Error',
          error: e, stackTrace: s);
      return defaultValue;
    }
  }

  static int createIntProperty(dynamic value, [int defaultvalue = 0]) {
    if (value == null) {
      return defaultvalue;
    }
    try {
      if (value is int) {
        return value;
      }

      if (value is String && isNotBlank(value)) {
        Dev.warn(
            'ModelUtils:createIntProperty -> value is String, converting to int');
        return int.tryParse(value) ?? 0;
      }

      if (value is double) {
        return int.tryParse(value.toString()) ?? 0;
      }

      return defaultvalue;
    } catch (e, s) {
      Dev.error('ModelUtils:createIntProperty Error', error: e, stackTrace: s);
      return defaultvalue;
    }
  }

  static double createDoubleProperty(dynamic value, [double? defaultValue]) {
    try {
      if (value == null) {
        return defaultValue ?? 0;
      }

      if (value is double) {
        return value;
      }

      if (value is String && isNotBlank(value)) {
        Dev.warn(
            'ModelUtils:createDoubleProperty -> value is String, converting to double');
        return double.tryParse(value) ?? 0;
      }

      if (value is int) {
        return double.tryParse(value.toString()) ?? 0;
      }

      return defaultValue ?? 0;
    } catch (e, s) {
      Dev.error(
        'ModelUtils:createDoubleProperty Error',
        error: e,
        stackTrace: s,
      );
      return defaultValue ?? 0;
    }
  }

  static bool createBoolProperty(dynamic value, [bool defaultValue = false]) {
    try {
      if (value == null) {
        return defaultValue;
      }

      if (value is bool) {
        return value;
      }

      if (value is String && isNotBlank(value)) {
        Dev.warn(
            'ModelUtils:createBoolProperty -> value is String, converting to bool');
        if (value.trim().toLowerCase() == 'true') {
          return true;
        } else {
          return defaultValue;
        }
      }
      return defaultValue;
    } catch (e, s) {
      Dev.error('ModelUtils:createBoolProperty Error', error: e, stackTrace: s);
      return defaultValue;
    }
  }

  static List<String> createListStrings(dynamic value) {
    try {
      if (value == null) {
        return const [];
      }

      if (value is List) {
        // If the value is list then cast the values to String type
        final List<String> tempList = [];

        for (var i = 0; i < value.length; ++i) {
          var o = value[i];
          if (o == null) {
            continue;
          }
          if (o is String) {
            tempList.add(o);
          } else {
            tempList.add(o.toString());
          }
        }
        return tempList;
      }

      return const [];
    } catch (_) {
      return const [];
    }
  }

  static List<T> createListOfType<T>(
    dynamic listOfMaps,
    T Function(Map<String, dynamic> elem) mappingFunction,
  ) {
    try {
      if (listOfMaps == null || listOfMaps is! List) {
        return const [];
      }

      if (listOfMaps.isEmpty) {
        return const [];
      }
      final tempList = <T>[];
      for (final obj in listOfMaps) {
        if (obj != null) {
          tempList.add(mappingFunction(obj));
        }
      }
      return tempList;
    } catch (e, s) {
      Dev.error('createListOfType error', error: e, stackTrace: s);
      return const [];
    }
  }

  static Set<T> createSetOfType<T>(
    dynamic listOfMaps,
    T Function(Map<String, dynamic> elem) mappingFunction,
  ) {
    try {
      if (listOfMaps == null || listOfMaps is! List) {
        return const {};
      }

      if (listOfMaps.isEmpty) {
        return const {};
      }
      final Set<T> tempSet = {};
      for (final obj in listOfMaps) {
        if (obj != null) {
          tempSet.add(mappingFunction(obj));
        }
      }
      return tempSet;
    } catch (e) {
      Dev.error('createListOfType error', error: e);
      return const {};
    }
  }

  static Map<T1, T2> createMapOfType<T1, T2>(
    dynamic value, [
    Map<T1, T2> defaultValue = const {},
  ]) {
    try {
      if (value == null) {
        return defaultValue;
      }

      if (value is! Map) {
        Dev.warn('Expected map but got type ${value.runtimeType}');
        Dev.info(value);
        Dev.warn('createMapOfType -> value is not map, returning...');
        return defaultValue;
      }

      // ignore: unnecessary_type_check
      if (value is Map) {
        return Map.from(value).cast<T1, T2>();
      }

      return defaultValue;
    } catch (e) {
      Dev.error('createMapOfType error', error: e);
      return defaultValue;
    }
  }
}
