import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/product.dart';
import 'package:sretnesapice_mobile/providers/order_item_provider.dart';
import 'package:sretnesapice_mobile/providers/product_provider.dart';
import 'package:sretnesapice_mobile/providers/product_type_provider.dart';
import 'package:sretnesapice_mobile/requests/order_item_request.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  String id;
  ProductDetailsScreen(this.id, {super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductProvider? _productProvider;
  ProductTypeProvider? _productTypeProvider;
  OrderItemProvider? _orderItemProvider = null;
  final int selectedIndex = 2;

  Product? product;
  List<Product> _recommendList = [];
  OrderItemRequest orderItemRequest = new OrderItemRequest();

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();
    _orderItemProvider = context.read<OrderItemProvider>();

    loadData();
    loadRecommendedList(this.widget.id);
  }

  Future loadData() async {
    var product = await _productProvider!.getById(int.parse(widget.id));

    setState(() {
      this.product = product;
    });
  }

  Future loadRecommendedList(String id) async {
    List<Product>? tempRecommendList =
        await _productProvider?.recommend(int.parse(id));
    setState(() {
      _recommendList = tempRecommendList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      loadData();
      return LoadingScreen();
    } else {
      return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductDetailsCard(),
                    SizedBox(height: 10),
                    Text("Preporučeno ",
                        style: TextStyle(color: Colors.blue, fontSize: 22)),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 200,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.5 / 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20),
                        scrollDirection: Axis.horizontal,
                        children: _buildRecommendedProductCardList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProductDetailsCard() {
    return Card(
      elevation: 4,
      color: Color.fromARGB(255, 6, 58, 137),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {},
              child: product!.productPhoto != ""
                  ? Container(
                      width: double.infinity,
                      child: imageFromBase64String(product!.productPhoto!),
                    )
                  : Container(),
            ),
            SizedBox(height: 10),
            Text(
              product!.name!,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    formatPrice(product!.price),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/cart.png',
                      width: 50,
                      height: 50,
                    ),
                    onPressed: () async {
                      try {
                        orderItemRequest.productId = product!.productID;
                        orderItemRequest.quantity = 1;

                        var orderedProduct =
                            await _orderItemProvider?.insert(orderItemRequest);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.blue[900],
                          content: Text('Uspješno dodano u korpu!',
                              style: TextStyle(color: Colors.white)),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            ),
            SizedBox(height: 20),
            // Title
            Text(
              product!.description!,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecommendedProductCardList() {
    if (_recommendList?.length == 0) {
      return [Text("Loading...")];
    }

    List<Widget> list = _recommendList!
        .map((x) => Container(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      "${ProductDetailsScreen.routeName}/${x.productID}");
                },
                child: Container(
                  child: imageFromBase64String(x.productPhoto!),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
