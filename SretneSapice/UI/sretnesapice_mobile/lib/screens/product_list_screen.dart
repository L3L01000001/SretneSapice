import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/product.dart';
import 'package:sretnesapice_mobile/providers/order_item_provider.dart';
import 'package:sretnesapice_mobile/providers/product_provider.dart';
import 'package:sretnesapice_mobile/requests/order_item_request.dart';
import 'package:sretnesapice_mobile/screens/product_details_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const String routeName = "/shop";
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductProvider? _productProvider = null;
  OrderItemProvider? _orderItemProvider = null;
  List<Product> data = [];
  TextEditingController _searchController = TextEditingController();
  String? _selectedSortingOption;

  final int selectedIndex = 2;

  OrderItemRequest orderItemRequest = new OrderItemRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _orderItemProvider = context.read<OrderItemProvider>();

    loadData();
  }

  Future loadData() async {
    var tmpData = await _productProvider?.get(null);
    setState(() {
      data = tmpData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductSearch(),
                SizedBox(height: 5),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: _buildSortingDropdown()),
                Container(
                  height: 700,
                  padding: EdgeInsets.all(26.0),
                  child: data.isEmpty
                      ? Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Center(child: CircularProgressIndicator()))
                      : GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 30),
                          scrollDirection: Axis.vertical,
                          children: _buildProductCardList(),
                        ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildSortingDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.blue[900],
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 50,
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Sortiraj po',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        dropdownColor: Colors.blue[900],
        iconDisabledColor: Colors.white,
        iconEnabledColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Najjeftinije') {
              var tmpdata =
                  await _productProvider!.get({'priceLtoH': true});
              setState(() {
                data = tmpdata;
              });
            } else if (_selectedSortingOption == 'Najskuplje') {
              var tmpdata =
                  await _productProvider!.get({'priceHtoL': true});
              setState(() {
                data = tmpdata;
              });
            } else if (_selectedSortingOption == 'Najnovije') {
              var tmpdata = await _productProvider!.get({'newest': true});
              setState(() {
                data = tmpdata;
              });
            } else {
              print('Sort opcija ne postoji.');
            }
          } catch (error) {
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Preporučeno',
          'Najjeftinije',
          'Najskuplje',
          'Najnovije'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.center,
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) async {
                var tmpData = await _productProvider?.get({'name': value});
                setState(() {
                  data = tmpData!;
                });
              },
              decoration: InputDecoration(
                  hintText: "Pretraga",
                  hintStyle: TextStyle(color: Colors.blue[900]),
                  labelStyle: TextStyle(color: Colors.blue[900]),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      'assets/icons/search-icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xff315ccc)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff315ccc)))),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProductCardList() {
    List<Widget> list = data
        .map((x) => Container(
              width: 130,
              height: 220,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xff315ccc),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '${ProductDetailsScreen.routeName}/${x.productID}',
                      );
                    },
                    child: x.productPhoto != ""
                        ? Container(
                            height: 110,
                            width: 110,
                            child: imageFromBase64String(x.productPhoto!),
                          )
                        : Icon(Icons.photo, size: 110, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(x.name ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 35,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          formatPrice(x.price),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: IconButton(
                          icon: Image.asset(
                            'assets/icons/cart.png',
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () async {
                            try {
                              orderItemRequest.productId = x.productID;
                              orderItemRequest.quantity = 1;

                              var orderedProduct = await _orderItemProvider
                                  ?.insert(orderItemRequest);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.blue[900],
                                content: Text('Uspješno dodano u korpu!',
                                    style: TextStyle(color: Colors.white)),
                              ));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 73, 14, 10),
                                content: Text('Greška!',
                                    style: TextStyle(color: Colors.white)),
                              ));
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
