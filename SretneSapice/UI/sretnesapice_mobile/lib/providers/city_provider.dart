import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("api/Cities");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
