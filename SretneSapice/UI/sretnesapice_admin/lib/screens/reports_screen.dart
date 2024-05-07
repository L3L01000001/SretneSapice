import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/providers/forum_post_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:sretnesapice_admin/providers/user_provider.dart';
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
  SearchResult<ForumPost>? forumPostsCount;
  SearchResult<Product>? productsCount;
  SearchResult<User>? usersCount;
  SearchResult<Order>? ordersCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forumPostProvider = context.read<ForumPostProvider>();
    _userProvider = context.read<UserProvider>();
    _productProvider = context.read<ProductProvider>();
    _orderProvider = context.read<OrderProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    var fpdata = await _forumPostProvider.get();
    var udata = await _userProvider.get();
    var pdata = await _productProvider.get();
    var odata = await _orderProvider.get();

    setState(() {
      forumPostsCount = fpdata;
      productsCount = pdata;
      usersCount = udata;
      ordersCount = odata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaji",
      initialIndex: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 26),
            Text(
              "Pregled izvještaja",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8031CC)),
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
                  title: 'Ukupno postova',
                  count: forumPostsCount?.result.length ?? 0,
                  color: Colors.purple,
                ),
                ReportCard(
                  title: 'Ukupno narudžbi',
                  count: ordersCount?.count ?? 0,
                  color: Colors.yellow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
