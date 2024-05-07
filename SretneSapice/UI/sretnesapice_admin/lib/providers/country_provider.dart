import 'package:sretnesapice_admin/models/country.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super("api/Countries");

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}
