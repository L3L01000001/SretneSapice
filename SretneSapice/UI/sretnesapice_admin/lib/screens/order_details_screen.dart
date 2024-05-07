import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/order_item.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/order_item_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  Order? order;
  OrderDetailsScreen({super.key, this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late OrderProvider _orderProvider;
  late OrderItemProvider _orderItemProvider;

  SearchResult<OrderItem>? orderItemsResult;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'orderId': widget.order?.orderId.toString(),
      'orderNumber': widget.order?.orderNumber,
      'user': widget.order?.userId.toString(),
      'shippingInfoId': widget.order?.shippingInfoId,
      'date': widget.order?.date,
      'status': widget.order?.status,
      'totalAmount': widget.order?.totalAmount?.toString()
    };

    _orderItemProvider = context.read<OrderItemProvider>();

    _loadOrderItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadOrderItems() async {
    if (widget.order?.orderId != null) {
      final orderItemsResult = await _orderItemProvider
          .get(filter: {'orderId': widget.order!.orderId!});

      setState(() {
        this.orderItemsResult = orderItemsResult;
        print(orderItemsResult);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: 3,
      child: Column(
        children: [
          buildOrderDetails(),
        ],
      ),
      title: this.widget.order?.orderNumber ?? "",
    );
  }

  Widget buildOrderDetails() {
    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETALJI NARUDŽBE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildOrderDetailRow(
                  "Broj narudžbe:", widget.order?.orderNumber ?? ""),
              buildOrderDetailRow(
                  "Korisnik:", widget.order?.user?.fullName ?? ""),
              buildOrderDetailRow(
                  "Datum:", widget.order?.date?.toString() ?? ""),
              buildOrderDetailRow(
                  "Status narudžbe:", widget.order?.status ?? ""),
              buildOrderDetailRow(
                  "Ukupni iznos:", widget.order?.totalAmount?.toString() ?? ""),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'NARUČENI PROIZVODI:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10),
          orderItemsResult != null && orderItemsResult!.result.isNotEmpty
              ? Column(
                  children: orderItemsResult!.result.map((orderItem) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          orderItem.product?.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Količina: ${orderItem.quantity}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: Text(
                          'Iznos: ${orderItem.subtotal.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text('Nema proizvoda.'),
        ],
      ),
    );
  }

  Widget buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
