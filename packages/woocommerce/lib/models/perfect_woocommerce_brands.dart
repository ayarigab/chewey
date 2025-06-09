/// ## Description
///
/// Model class to support brands information with wordpress plugin
/// `Perfect WooCommerce Brands`
class PerfectWooCommerceBrand {
  final int? id;
  final String? name;
  final String? slug;

//<editor-fold desc="Data Methods">

  const PerfectWooCommerceBrand({
    this.id,
    this.name,
    this.slug,
  });

  @override
  String toString() {
    return 'PerfectWooCommerceBrand{' +
        ' id: $id,' +
        ' name: $name,' +
        ' slug: $slug,' +
        '}';
  }

  PerfectWooCommerceBrand copyWith({
    int? id,
    String? name,
    String? slug,
  }) {
    return PerfectWooCommerceBrand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'slug': this.slug,
    };
  }

  factory PerfectWooCommerceBrand.fromMap(Map<String, dynamic> map) {
    return PerfectWooCommerceBrand(
      id: map['id'] != null ? map['id'] as int? : 0,
      name: map['name'] != null ? map['name'] as String? : '',
      slug: map['slug'] != null ? map['slug'] as String? : '',
    );
  }

//</editor-fold>
}
