class WooCountry {
  final String? code;
  final String? name;
  final List<WooState>? states;

  const WooCountry({
    this.code,
    this.name,
    this.states,
  });

  factory WooCountry.fromMap(Map<String, dynamic> map) {
    return WooCountry(
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      states: map['states'] != null
          ? (map['states'] as List)
              .map<WooState>((e) => WooState.fromMap(e))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'code': code,
      'name': name,
      'states': states,
    } as Map<String, dynamic>;
  }
}

/// Data object for states data from woocommerce
class WooState {
  final String? code;
  final String? name;

  const WooState({
    this.code,
    this.name,
  });

  factory WooState.fromMap(Map<String, dynamic> map) {
    return WooState(
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
    };
  }
}
