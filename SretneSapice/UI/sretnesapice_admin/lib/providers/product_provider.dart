import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/utils/util.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  Future<SearchResult<Product>> getProductsByPriceLowToHigh() async {
    var url = "$totalUrl/Price-low-to-high";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Product>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  Future<SearchResult<Product>> getProductsByPriceHighToLow() async {
    var url = "$totalUrl/Price-high-to-low";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Product>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  Future<SearchResult<Product>> getNewestProducts() async {
    var url = "$totalUrl/Newest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Product>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
