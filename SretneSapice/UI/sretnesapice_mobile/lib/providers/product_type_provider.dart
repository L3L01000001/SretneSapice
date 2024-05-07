import 'package:sretnesapice_mobile/models/product_type.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class ProductTypeProvider extends BaseProvider<ProductType> {
  ProductTypeProvider() : super("api/ProductTypes");

  @override
  ProductType fromJson(data) {
    return ProductType.fromJson(data);
  }
}