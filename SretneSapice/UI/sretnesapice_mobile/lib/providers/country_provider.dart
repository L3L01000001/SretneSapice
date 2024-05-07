import 'package:sretnesapice_mobile/models/country.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super("api/Countries");

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}
