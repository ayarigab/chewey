class WooProductTaxonomyQuery {
  final String taxonomySlug;
  final int termId;
  final String field = 'term_id';

  const WooProductTaxonomyQuery(
    this.taxonomySlug,
    this.termId,
  );

  @override
  bool operator ==(Object other) =>
      other is WooProductTaxonomyQuery &&
      taxonomySlug == other.taxonomySlug &&
      termId == other.termId;

  @override
  int get hashCode => taxonomySlug.hashCode ^ termId.hashCode;
}
