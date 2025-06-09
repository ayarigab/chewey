class WPICartTotals {
  final String? cartContentsTax;
  final String? cartContentsTotal;
  final String? discountTax;
  final String? discountTotal;
  final String? feeTax;
  final String? feeTotal;
  final String? shippingTax;
  final String? shippingTotal;
  final String? subtotal;
  final String? subtotalTax;
  final String? total;
  final String? totalTax;

  const WPICartTotals({
    this.cartContentsTax = '',
    this.cartContentsTotal = '',
    this.discountTax = '',
    this.discountTotal = '',
    this.feeTax = '',
    this.feeTotal = '',
    this.shippingTax = '',
    this.shippingTotal = '',
    this.subtotal = '',
    this.subtotalTax = '',
    this.total = '',
    this.totalTax = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'cartContentsTax': this.cartContentsTax,
      'cartContentsTotal': this.cartContentsTotal,
      'discountTax': this.discountTax,
      'discountTotal': this.discountTotal,
      'feeTax': this.feeTax,
      'feeTotal': this.feeTotal,
      'shippingTax': this.shippingTax,
      'shippingTotal': this.shippingTotal,
      'subtotal': this.subtotal,
      'subtotalTax': this.subtotalTax,
      'total': this.total,
      'totalTax': this.totalTax,
    };
  }

  factory WPICartTotals.fromMap(Map<String, dynamic> map) {
    return WPICartTotals(
      cartContentsTax: map['cart_contents_tax']?.toString() ?? '',
      cartContentsTotal: map['cart_contents_total']?.toString() ?? '',
      discountTax: map['discount_tax']?.toString() ?? '',
      discountTotal: map['discount_total']?.toString() ?? '',
      feeTax: map['fee_tax']?.toString() ?? '',
      feeTotal: map['fee_total']?.toString() ?? '',
      shippingTax: map['shipping_tax']?.toString() ?? '',
      shippingTotal: map['shipping_total']?.toString() ?? '',
      subtotal: map['subtotal']?.toString() ?? '',
      subtotalTax: map['subtotal_tax']?.toString() ?? '',
      total: map['total']?.toString() ?? '',
      totalTax: map['total_tax']?.toString() ?? '',
    );
  }
}
