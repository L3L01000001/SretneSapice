import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/dog_walker.dart';
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/providers/dog_walker_provider.dart';
import 'package:sretnesapice_admin/providers/forum_post_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:sretnesapice_admin/providers/user_provider.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';
import 'package:sretnesapice_admin/widgets/report_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ForumPostProvider _forumPostProvider;
  late UserProvider _userProvider;
  late ProductProvider _productProvider;
  late OrderProvider _orderProvider;
  late DogWalkerProvider _dogWalkerProvider;
  SearchResult<ForumPost>? forumPostsCount;
  SearchResult<Product>? productsCount;
  SearchResult<User>? usersCount;
  SearchResult<Order>? ordersCount;
  SearchResult<DogWalker>? dogWalkerCount;

  SearchResult<ForumPost>? top5FP;
  SearchResult<Product>? top5P;
  SearchResult<Order>? top5O;
  SearchResult<DogWalker>? top5DW;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forumPostProvider = context.read<ForumPostProvider>();
    _userProvider = context.read<UserProvider>();
    _productProvider = context.read<ProductProvider>();
    _orderProvider = context.read<OrderProvider>();
    _dogWalkerProvider = context.read<DogWalkerProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    var fpdata = await _forumPostProvider.get();
    var udata = await _userProvider.get();
    var pdata = await _productProvider.get();
    var odata = await _orderProvider.get();
    var dwdata = await _dogWalkerProvider.get();

    var top5fp = await _forumPostProvider.get(filter: {'top5': true});
    var top5p = await _productProvider.get(filter: {'top5': true});
    var top5dw = await _dogWalkerProvider.get(filter: {'top5': true});
    var top5o = await _orderProvider.get(filter: {'top5': true});

    setState(() {
      forumPostsCount = fpdata;
      productsCount = pdata;
      usersCount = udata;
      ordersCount = odata;
      dogWalkerCount = dwdata;
      top5FP = top5fp;
      top5DW = top5dw;
      top5P = top5p;
      top5O = top5o;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaji",
      initialIndex: 4,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 26),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.5),
                      Colors.blue.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "Pregled izvještaja",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReportCard(
                    title: 'Ukupno proizvoda',
                    count: productsCount?.result.length ?? 0,
                    color: Colors.blue,
                  ),
                  ReportCard(
                    title: 'Ukupno korisnika',
                    count: usersCount?.count ?? 0,
                    color: Colors.green,
                  ),
                  ReportCard(
                    title: 'Ukupno šetača',
                    count: dogWalkerCount?.count ?? 0,
                    color: Colors.pink,
                  ),
                  ReportCard(
                    title: 'Ukupno postova',
                    count: forumPostsCount?.count ?? 0,
                    color: Colors.purple,
                  ),
                  ReportCard(
                    title: 'Ukupno narudžbi',
                    count: ordersCount?.count ?? 0,
                    color: Colors.yellow,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "TOP 5 najpopularnijih forum postova",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTop5ForumPostsDataTable(),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      const Color.fromARGB(255, 4, 82, 145)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "TOP 5 najprodavanijih proizvoda",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTop5ProductsDataTable(),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 234, 73, 127),
                      const Color.fromARGB(255, 221, 3, 76)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "TOP 5 šetača s najviše usluga",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTop5DogWalkersDataTable(),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow,
                      const Color.fromARGB(255, 193, 174, 0)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "TOP 5 narudžbi",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTop5OrdersDataTable()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop5ForumPostsDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: top5FP != null && top5FP!.result.isNotEmpty
            ? DataTable(
                border: TableBorder.all(
                  style: BorderStyle.solid,
                  color: Colors.purple,
                ),
                headingRowHeight: 30,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.purple),
                dataRowMaxHeight: 50,
                dataRowMinHeight: 30,
                columns: [
                  const DataColumn(
                    label: Expanded(
                      child: Text('Autor posta',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Naslov',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Sadržaj',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Vrijeme kreiranja',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Tagovi',
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
                ],
                rows: top5FP!.result
                    .map(
                      (ForumPost e) => DataRow(
                        onLongPress: () => {},
                        cells: [
                          DataCell(Text(e.user?.fullName ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.title ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.postContent ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(formatDate(e.timestamp),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(
                            Text(
                                (e.tags
                                        ?.map((tag) => tag?.tagName)
                                        .join(', ') ??
                                    'Nema tagova'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          DataCell(e.photo != ""
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: imageFromBase64String(e.photo!),
                                )
                              : Text("Nema slike",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))),
                        ],
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: Text(
                  'Nema postova!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }

  Widget _buildTop5ProductsDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: top5P != null && top5P!.result.isNotEmpty
            ? DataTable(
                border: TableBorder.all(
                  style: BorderStyle.solid,
                  color: Colors.blue,
                ),
                headingRowHeight: 30,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
                dataRowMaxHeight: 50,
                dataRowMinHeight: 30,
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
                ],
                rows: top5P!.result
                    .map(
                      (Product e) => DataRow(
                        onLongPress: () => {},
                        cells: [
                          DataCell(Text(e.productID?.toString() ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(e.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                          ),
                          DataCell(Text(e.code ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 250),
                              child: Text(e.description ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                          ),
                          DataCell(Text(formatNumber(e.price),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.stockQuantity?.toString() ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(e.productPhoto != ""
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: imageFromBase64String(e.productPhoto!),
                                )
                              : Text("Nema slike")),
                        ],
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: Text(
                  'Nema dovoljno prozivoda!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }

  Widget _buildTop5DogWalkersDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: top5DW != null && top5DW!.result.isNotEmpty
            ? DataTable(
                border: TableBorder.all(
                  style: BorderStyle.solid,
                  color: Colors.pink,
                ),
                headingRowHeight: 30,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.pink),
                dataRowMaxHeight: 50,
                dataRowMinHeight: 30,
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
                      child: Text('Ime',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Prezime',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Godine',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Telefon',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Iskustvo',
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
                      child: Text('Slika',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 242, 237, 247),
                              fontSize: 18)),
                    ),
                  ),
                ],
                rows: top5DW!.result
                    .map(
                      (DogWalker e) => DataRow(
                        onLongPress: () => {},
                        cells: [
                          DataCell(Text(e.dogWalkerId?.toString() ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.name ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.surname ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.age.toString() ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.phone ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.experience ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(Text(e.status ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                          DataCell(e.dogWalkerPhoto != ""
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child:
                                      imageFromBase64String(e.dogWalkerPhoto!),
                                )
                              : Text("Nema slike")),
                        ],
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: Text(
                  'Nema šetača!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }

  Widget _buildTop5OrdersDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: top5O != null && top5O!.result.isNotEmpty
            ? DataTable(
                border: TableBorder.all(
                  style: BorderStyle.solid,
                  color: const Color.fromARGB(255, 198, 181, 33),
                ),
                headingRowHeight: 30,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 208, 193, 53)),
                dataRowMaxHeight: 50,
                dataRowMinHeight: 30,
                columns: [
                  DataColumn(
                    label: Text('Broj narudžbe',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 237, 247),
                            fontSize: 18)),
                  ),
                  DataColumn(
                    label: Text('Korisnik',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 237, 247),
                            fontSize: 18)),
                  ),
                  DataColumn(
                    label: Text('Datum narudžbe',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 237, 247),
                            fontSize: 18)),
                  ),
                  DataColumn(
                    label: Text('Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 237, 247),
                            fontSize: 18)),
                  ),
                  DataColumn(
                    label: Text('Ukupni iznos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 237, 247),
                            fontSize: 18)),
                  )
                ],
                rows: top5O!.result
                    .map(
                      (Order e) => DataRow(
                        onLongPress: () => {},
                        cells: [
                          DataCell(Text(e.orderNumber ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                          DataCell(Text(e.user?.fullName ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                          DataCell(Text(e.date ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                          DataCell(Text(e.status ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                          DataCell(Text(e.totalAmount?.toString() ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                        ],
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: Text(
                  'Nema narudžbi!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}
