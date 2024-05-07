
import 'package:sretnesapice_mobile/providers/base_provider.dart';
import 'package:sretnesapice_mobile/models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");
  
  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
