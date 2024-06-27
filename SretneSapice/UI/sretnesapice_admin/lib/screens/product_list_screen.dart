import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:sretnesapice_admin/screens/product_details_screen.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  SearchResult<Product>? result;
  TextEditingController _nameController = TextEditingController();
  String? _selectedSortingOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _productProvider.get();

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Proizvodi",
      initialIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearch(),
            SizedBox(height: 16),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildSortingDropdown()]),
            SizedBox(height: 16),
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.grey[100], 
        border: Border.all(
            color: Color.fromARGB(255, 61, 6, 137),
            width: 1.0), 
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Ime proizvoda",
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _nameController.clear();
                        });
                      },
                    )
                  : null,
            ),
            controller: _nameController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            var data = await _productProvider
                .get(filter: {'name': _nameController.text});
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
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: null,
                ),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text("Novi proizvod"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(0xFF8031CC), width: 2.0),
            ),
          ),
        ),
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
                'Sortiraj po',
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
            if (_selectedSortingOption == 'Najjeftinije') {
              var data = await _productProvider.getProductsByPriceLowToHigh();
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Najskuplje') {
              var data = await _productProvider.getProductsByPriceHighToLow();
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Najnovije') {
              var data = await _productProvider.getNewestProducts();
              setState(() {
                result = data;
              });
            } else {
              // Handle case when selected sorting option doesn't match any predefined option
              print('Invalid sorting option');
            }
          } catch (error) {
            // Handle error when fetching data fails
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Sortiraj po',
          'Najjeftinije',
          'Najskuplje',
          'Najnovije'
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
                        child: Text('ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Ime proizvoda',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Šifra',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Opis',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Cijena',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Količina zaliha',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Slika',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ],
                  rows: result!.result
                      .map(
                        (Product e) => DataRow(
                          onLongPress: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: e,
                                ),
                              ),
                            )
                          },
                          cells: [
                            DataCell(Text(e.productID?.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.name ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.code ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.description ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(formatNumber(e.price),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.stockQuantity?.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(e.productPhoto != ""
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child:
                                        imageFromBase64String(e.productPhoto!),
                                  )
                                : Text("Nema slike")),
                            DataCell(GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Brisanje proizvoda"),
                                      content: Text(
                                          "Jeste li sigurni da želite obrisati proizvod?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await _productProvider
                                                .hardDelete(e.productID!);

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          content: Text(
                                                              "Proizvod uspješno obrisan iz baze!"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ProductListScreen(),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text("OK"),
                                                            )
                                                          ],
                                                        ));
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: Text("Obriši",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: Text("Odustani"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.delete,
                                  color: Color.fromARGB(255, 233, 21, 14)),
                            ))
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: Text(
                  'Nema proizvoda koji sadrže traženu riječ/slovo u imenu!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}
