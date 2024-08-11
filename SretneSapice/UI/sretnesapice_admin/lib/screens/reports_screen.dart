import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/dog_walker.dart';
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/requests_by_status.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/providers/dog_walker_provider.dart';
import 'package:sretnesapice_admin/providers/forum_post_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:sretnesapice_admin/providers/report_provider.dart';
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
  late ReportProvider _reportProvider;

  SearchResult<ForumPost>? forumPostsCount;
  SearchResult<Product>? productsCount;
  SearchResult<User>? usersCount;
  SearchResult<Order>? ordersCount;
  SearchResult<DogWalker>? dogWalkerCount;

  SearchResult<ForumPost>? top5FP;
  SearchResult<Product>? top5P;
  SearchResult<Order>? top5O;
  SearchResult<DogWalker>? top5DW;

  bool _isForumPostsExpanded = false;
  bool _isProductsExpanded = false;
  bool _isDogWalkersExpanded = false;
  bool _isOrdersExpanded = false;

  DateTime? fromDate;
  DateTime? toDate;

  int? filteredCountOfServiceRequests;
  List<RequestsByStatus> filteredList = [];

  DateTime getStartOfWeek(DateTime date) {
    int daysSinceMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysSinceMonday)).subtract(Duration(
        hours: date.hour,
        minutes: date.minute,
        seconds: date.second,
        milliseconds: date.millisecond,
        microseconds: date.microsecond));
  }

  DateTime getEndOfWeek(DateTime startOfWeek) {
    return startOfWeek
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime getEndOfMonth(DateTime date) {
    DateTime startOfNextMonth = DateTime(date.year, date.month + 1, 1);
    return startOfNextMonth.subtract(Duration(seconds: 1));
  }

  Future<int> _getRequestsCount(DateTime start, [DateTime? end]) async {
    return await _reportProvider
        .getTotalRequests(filter: {'dateFrom': start, 'dateTo': end});
  }

  Future<List<RequestsByStatus>> _getStatusBreakdown(DateTime start,
      [DateTime? end]) async {
    return await _reportProvider
        .getStatusBreakdown(filter: {'dateFrom': start, 'dateTo': end});
  }

  int? todayCount;
  int? weekCount;
  int? monthCount;
  List<RequestsByStatus>? todayBreakdown;
  List<RequestsByStatus>? weekBreakdown;
  List<RequestsByStatus>? monthBreakdown;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _fetchPieChartData() async {
    var todayStart =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var todayEnd = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    DateTime startOfWeek = getStartOfWeek(todayStart);
    DateTime endOfWeek = getEndOfWeek(startOfWeek);
    DateTime startOfMonth = getStartOfMonth(todayStart);
    DateTime endOfMonth = getEndOfMonth(todayStart);

    setState(() {
      isLoading = true;
    });

    try {
      final todayCountFuture = _getRequestsCount(todayStart, todayEnd);
      final weekCountFuture = _getRequestsCount(startOfWeek, endOfWeek);
      final monthCountFuture = _getRequestsCount(startOfMonth, endOfMonth);
      final todayBreakdownFuture = _getStatusBreakdown(todayStart, todayEnd);
      final weekBreakdownFuture = _getStatusBreakdown(startOfWeek, endOfWeek);
      final monthBreakdownFuture =
          _getStatusBreakdown(startOfMonth, endOfMonth);

      final results = await Future.wait([
        todayCountFuture,
        weekCountFuture,
        monthCountFuture,
        todayBreakdownFuture,
        weekBreakdownFuture,
        monthBreakdownFuture,
      ]);

      setState(() {
        todayCount = results[0] as int;
        weekCount = results[1] as int;
        monthCount = results[2] as int;
        todayBreakdown = results[3] as List<RequestsByStatus>;
        weekBreakdown = results[4] as List<RequestsByStatus>;
        monthBreakdown = results[5] as List<RequestsByStatus>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forumPostProvider = context.read<ForumPostProvider>();
    _userProvider = context.read<UserProvider>();
    _productProvider = context.read<ProductProvider>();
    _orderProvider = context.read<OrderProvider>();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _reportProvider = context.read<ReportProvider>();

    _loadData();
    _fetchPieChartData();

    print(todayCount);
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

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate && picked != toDate) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ReportCard(
                      title: 'Ukupno proizvoda',
                      count: productsCount?.result.length ?? 0,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: ReportCard(
                      title: 'Ukupno korisnika',
                      count: usersCount?.count ?? 0,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: ReportCard(
                      title: 'Ukupno šetača',
                      count: dogWalkerCount?.count ?? 0,
                      color: Colors.pink,
                    ),
                  ),
                  Expanded(
                    child: ReportCard(
                      title: 'Ukupno postova',
                      count: forumPostsCount?.count ?? 0,
                      color: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: ReportCard(
                      title: 'Ukupno narudžbi',
                      count: ordersCount?.count ?? 0,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildCollapsibleSection(
                title: "TOP 5 najpopularnijih forum postova",
                isExpanded: _isForumPostsExpanded,
                onTap: () {
                  setState(() {
                    _isForumPostsExpanded = !_isForumPostsExpanded;
                  });
                },
                content: _buildTop5ForumPostsDataTable(),
                gradientColors: [Colors.purple, Colors.deepPurple],
              ),
              SizedBox(height: 30),
              _buildCollapsibleSection(
                title: "TOP 5 najprodavanijih proizvoda",
                isExpanded: _isProductsExpanded,
                onTap: () {
                  setState(() {
                    _isProductsExpanded = !_isProductsExpanded;
                  });
                },
                content: _buildTop5ProductsDataTable(),
                gradientColors: [Colors.blue, Color.fromARGB(255, 4, 82, 145)],
              ),
              SizedBox(height: 30),
              _buildCollapsibleSection(
                title: "TOP 5 šetača s najviše usluga",
                isExpanded: _isDogWalkersExpanded,
                onTap: () {
                  setState(() {
                    _isDogWalkersExpanded = !_isDogWalkersExpanded;
                  });
                },
                content: _buildTop5DogWalkersDataTable(),
                gradientColors: [
                  Color.fromARGB(255, 234, 73, 127),
                  Color.fromARGB(255, 221, 3, 76)
                ],
              ),
              SizedBox(height: 30),
              _buildCollapsibleSection(
                title: "TOP 5 narudžbi",
                isExpanded: _isOrdersExpanded,
                onTap: () {
                  setState(() {
                    _isOrdersExpanded = !_isOrdersExpanded;
                  });
                },
                content: _buildTop5OrdersDataTable(),
                gradientColors: [
                  Colors.yellow,
                  Color.fromARGB(255, 193, 174, 0)
                ],
              ),
              SizedBox(height: 30),
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
                  "Pregled šetačkih usluga",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (isLoading) Center(child: CircularProgressIndicator()),
              if (!isLoading &&
                  todayCount != null &&
                  weekCount != null &&
                  monthCount != null &&
                  todayBreakdown != null &&
                  weekBreakdown != null &&
                  monthBreakdown != null)
                _buildRequestCounts(
                  [todayCount!, weekCount!, monthCount!],
                  [todayBreakdown!, weekBreakdown!, monthBreakdown!],
                ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text("Generiši izvještaj za period od",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 53, 3, 61),
                          Color.fromARGB(255, 10, 77, 119)
                        ])),
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Text(
                          fromDate != null
                              ? formatDateOnly(fromDate)
                              : 'Izaberi datum',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text("do", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 53, 3, 61),
                          Color.fromARGB(255, 10, 77, 119)
                        ])),
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Text(
                          toDate != null ? formatDateOnly(toDate) : 'Izaberi datum',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.all(20),
                        fixedSize: Size.fromWidth(300)
                      ),
                    onPressed: () async {
                      if (fromDate != null && toDate != null) {
                        var number = await _reportProvider.getTotalRequests(
                            filter: {'dateFrom': fromDate, 'dateTo': toDate});

                        var list = await _reportProvider.getStatusBreakdown(
                            filter: {'dateFrom': fromDate, 'dateTo': toDate});

                        setState(() {
                          filteredCountOfServiceRequests = number;
                          filteredList = list;
                        });
                      }
                    },
                    child: Text('Filtriraj',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (filteredCountOfServiceRequests != null &&
                  filteredList.isNotEmpty)
                _buildCountCard(
                    "Izvještaj šetačkih usluga za odabrani vremenski period",
                    filteredCountOfServiceRequests!,
                    filteredList)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
    required List<Color> gradientColors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: content,
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
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
                          DataCell(Text(formatDate(e.date),
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

  Widget _buildRequestCounts(
      List<int> counts, List<List<RequestsByStatus>> breakdowns) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildCountCard('Danas', counts[0], breakdowns[0])),
        Expanded(
            child: _buildCountCard('Ove sedmice', counts[1], breakdowns[1])),
        Expanded(
            child: _buildCountCard('Ovog mjeseca', counts[2], breakdowns[2])),
      ],
    );
  }

  Widget _buildCountCard(String label, int count, List<RequestsByStatus> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('$count', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            _buildPieChart(data)
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<RequestsByStatus> data) {
    final Map<String, double> dataMap = {
      for (var item in data) item.status!: item.count!.toDouble(),
    };

    final List<Color> colorList = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartRadius: 100,
        colorList: colorList,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        legendOptions: LegendOptions(
          showLegendsInRow: true,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }
}
