import 'dart:convert';

import 'package:sretnesapice_mobile/models/search_result.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';
import 'package:sretnesapice_mobile/models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  Future<List<Product>> recommend(int id, [dynamic additionalData]) async {
    var url = Uri.parse("$totalUrl/Recommend/$id");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);

      List<Product> list = data.map((x) => fromJson(x)).cast<Product>().toList(); 
      return list;
    } else {
      throw Exception("Greška!");
    }
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
