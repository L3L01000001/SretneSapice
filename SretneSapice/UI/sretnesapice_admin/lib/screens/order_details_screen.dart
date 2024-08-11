import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/order_item.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/order_item_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
      });
    }
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('DETALJI NARUDZBE',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 22)),
              pw.SizedBox(height: 10),
              pw.Text('Broj narudzbe: ${widget.order?.orderNumber ?? ""}'),
              pw.Text('Korisnik: ${widget.order?.user?.fullName ?? ""}'),
              pw.Text('Datum: ${widget.order?.date ?? ""}'),
              pw.Text('Status narudzbe: ${widget.order?.status ?? ""}'),
              pw.Text(
                  'Ukupni iznos: ${widget.order?.totalAmount?.toString() ?? ""}'),
              pw.SizedBox(height: 20),
              pw.Text('NARUCENI PROIZVODI:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 22)),
              pw.SizedBox(height: 10),
              ...?orderItemsResult?.result.map((orderItem) {
                return pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.grey, width: 0.5)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                          child: pw.Text(orderItem.product?.name ?? "")),
                      pw.Text('Kolicina: ${orderItem.quantity}'),
                      pw.Text('Iznos: ${orderItem.subtotal.toString()}'),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final pdfData = await pdf.save();
    return pdfData;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: 3,
      child: Padding(
        padding: EdgeInsets.all(26.0),
        child: Column(
          children: [
            buildOrderDetails(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 53, 3, 61),
                              Color.fromARGB(255, 10, 77, 119)
                            ])),
                        child: ElevatedButton(
                          onPressed: () async {
                            final pdfData = await _generatePdf();
                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async => pdfData,
                            );
                          },
                          child: Text("Generiši PDF",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(20),
                          ),
                        )))
              ],
            )
          ],
        ),
      ),
      title: this.widget.order?.orderNumber ?? "",
    );
  }

  Widget buildOrderDetails() {
    return Container(
      color: Color.fromARGB(255, 223, 212, 244),
      padding: EdgeInsets.all(20),
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
                  "Datum:", formatDate(widget.order?.date).toString() ?? ""),
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
