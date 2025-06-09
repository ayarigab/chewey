import 'package:decapitalgrille/page/orders/view_order.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/orders_model.dart';
import 'package:flutter/services.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          Core.smoothFadePageRoute(
            context,
            ViewOrderPage(
              orderNumber: order.orderNumber,
              orderID: order.orderID,
              customerID: order.customerID,
              customerNote: order.customerNote,
              customerBilling: order.customerBilling,
              customerShipping: order.customerShipping,
              orderParentID: order.orderParentID,
              orderProducts: order.orderProducts,
              orderShipping: order.orderShipping,
              totalAmount: order.totalAmount,
              status: order.status,
              discountAmt: order.discountAmt,
              shippingAmt: order.shippingAmt,
              totalTax: order.totalTax,
              totalAmt: order.totalAmt,
              date: order.date,
              dateMod: order.dateMod,
              isPaid: order.isPaid,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Number: #${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontVariations: [FontVariation('wght', 900)],
                        ),
                      ),
                      Core.inform(
                          text:
                              'Total Amt: $currency ${order.totalAmount.toStringAsFixed(2)}')
                    ],
                  ),
                  Row(
                    children: [
                      NielButton(
                        id: 'copy_order_no',
                        foregroundColor: Colors.green,
                        background: Colors.transparent,
                        leftIcon: const Icon(
                          FluentIcons.clipboard_20_filled,
                          color: Colors.green,
                        ),
                        text: 'Copy#',
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: "Decapital Order #${order.orderNumber}",
                            ),
                          );
                          if (context.mounted) {
                            Core.snackThis(
                              context: context,
                              'Copied Order #${order.orderNumber} successfully',
                            );
                          }
                        },
                        type: NielButtonType.SECONDARY,
                        defaultBorderColor: Colors.green,
                        borderLineWidth: 1,
                        size: NielButtonSize.XS,
                        borderRadius: 4,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      NielButton(
                        id: 'view_order',
                        foregroundColor: NielCol.white,
                        leftIcon: const Icon(
                          FluentIcons.eye_20_filled,
                          color: NielCol.white,
                        ),
                        background: Colors.red.shade300,
                        text: 'View',
                        onPressed: () {
                          Navigator.of(context).push(
                            Core.smoothFadePageRoute(
                              context,
                              ViewOrderPage(
                                orderNumber: order.orderNumber,
                                orderID: order.orderID,
                                customerID: order.customerID,
                                customerNote: order.customerNote,
                                customerBilling: order.customerBilling,
                                customerShipping: order.customerShipping,
                                orderParentID: order.orderParentID,
                                orderProducts: order.orderProducts,
                                orderShipping: order.orderShipping,
                                totalAmount: order.totalAmount,
                                status: order.status,
                                discountAmt: order.discountAmt,
                                shippingAmt: order.shippingAmt,
                                totalTax: order.totalTax,
                                totalAmt: order.totalAmt,
                                date: order.date,
                                dateMod: order.dateMod,
                                isPaid: order.isPaid,
                              ),
                            ),
                          );
                        },
                        size: NielButtonSize.XS,
                        borderRadius: 4,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildStatusBadge(order.status),
                      const SizedBox(width: 3),
                      _buildPayStatus(order.isPaid),
                    ],
                  ),
                  Text(
                    '${order.date.day}/${order.date.month}/${order.date.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'cancelled':
        color = Colors.red;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green.shade300;
        break;
      case 'pending':
        color = Colors.purple;
        break;
      case 'refunded':
        color = Colors.orange;
        break;
      case 'processing':
        color = Colors.grey.shade400;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPayStatus(bool isPaid) {
    Color color;
    if (isPaid == true) {
      color = Colors.green.shade600;
    } else if (isPaid == false) {
      color = Colors.amber;
    } else {
      color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
      ),
      child: Text(
        isPaid ? 'Paid' : 'Unpaid',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
