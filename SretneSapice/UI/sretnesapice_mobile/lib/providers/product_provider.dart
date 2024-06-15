import 'dart:convert';

import 'package:sretnesapice_mobile/models/search_result.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';
import 'package:sretnesapice_mobile/models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  Future<List<Product>> getProductsByPriceLowToHigh() async {
    var url = "$totalUrl/Price-low-to-high";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<Product>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<Product>> getProductsByPriceHighToLow() async {
    var url = "$totalUrl/Price-high-to-low";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<Product>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<Product>> getNewestProducts() async {
    var url = "$totalUrl/Newest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<Product>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
