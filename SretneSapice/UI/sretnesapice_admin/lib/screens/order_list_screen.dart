import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/screens/order_details_screen.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late OrderProvider _orderProvider;
  SearchResult<Order>? result;
  TextEditingController _orderNumberController = TextEditingController();
  String? _selectedSortingOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderProvider = context.read<OrderProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _orderProvider.get();

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Narudžbe",
      initialIndex: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildSearch(),
          SizedBox(height: 16),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildSortingDropdown()]),
          SizedBox(height: 16),
          _buildDataListView()
        ]),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.grey[100],
        border: Border.all(color: Color.fromARGB(255, 61, 6, 137), width: 1.0),
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Broj narudžbe",
              suffixIcon: _orderNumberController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _orderNumberController.clear();
                        });
                      },
                    )
                  : null,
            ),
            controller: _orderNumberController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            // Navigator.of(context).pop();

            var data = await _orderProvider
                .get(filter: {'orderNumber': _orderNumberController.text});
            setState(() {
              result = data;
            });
          },
          icon: Icon(Icons.search),
          label: Text("Pretraga"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(0xFF8031CC), width: 2.0),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        )
      ]),
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 225, 238, 249),
          borderRadius: BorderRadius.circular(30),
          border:
              Border.all(width: 2.0, color: Color.fromARGB(255, 6, 58, 137))),
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Status narudžbe',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color.fromARGB(255, 6, 58, 137)),
              ),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(30),
        padding: EdgeInsets.all(8.0),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Plaćeno') {
              var data = await _orderProvider.get(filter: {'status': 'Paid'});
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'U korpi') {
              var data = await _orderProvider.get(filter: {'status': 'In Cart'});
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Procesuirano') {
              var data = await _orderProvider.get(filter: {'status': 'Processing'});
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Poslano') {
              var data = await _orderProvider.get(filter: {'status': 'Shipped'});
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Otkazano') {
              var data = await _orderProvider.get(filter: {'status': 'Cancelled'});
              setState(() {
                result = data;
              });
            } else {
              print('Invalid sorting option');
            }
          } catch (error) {
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Sortiraj po:',
          'Plaćeno',
          'U korpi',
          'Procesuirano',
          'Poslano',
          'Otkazano'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.center,
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: result != null && result!.result.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: DataTable(
                  border: TableBorder.all(
                    style: BorderStyle.solid,
                    color: Color.fromARGB(255, 57, 152, 199),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  headingRowHeight: 50,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color.fromARGB(255, 6, 58, 137)),
                  dataRowMaxHeight: 150,
                  dataRowMinHeight: 60,
                  columns: [
                    const DataColumn(
                      label: Expanded(
                        child: Text('Broj narudžbe',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Korisnik',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Datum narudžbe',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Ukupni iznos',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    )
                  ],
                  rows: result!.result
                      .map(
                        (Order e) => DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            return Colors.white; //
                          }),
                          onLongPress: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsScreen(
                                  order: e,
                                ),
                              ),
                            )
                          },
                          cells: [
                            DataCell(Text(e.orderNumber ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                            DataCell(Text(e.user?.fullName ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                            DataCell(Text(formatDate(e.date),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                            DataCell(Text(e.status ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                            DataCell(Text(e.totalAmount?.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: Text(
                  'Broj narudžbe ne postoji!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}
