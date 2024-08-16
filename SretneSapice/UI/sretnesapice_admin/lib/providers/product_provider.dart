import 'package:sretnesapice_admin/providers/base_provider.dart';
import 'package:sretnesapice_admin/models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
