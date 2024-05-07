import 'package:sretnesapice_admin/models/city.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("api/Cities");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
