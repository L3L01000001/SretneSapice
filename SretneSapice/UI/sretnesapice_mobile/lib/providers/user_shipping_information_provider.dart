import 'package:sretnesapice_mobile/models/user_shipping_information.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class UserShippingInformationProvider extends BaseProvider<UserShippingInformation> {
  UserShippingInformationProvider() : super("UserShippingInformation");

  @override
  UserShippingInformation fromJson(data) {
    return UserShippingInformation.fromJson(data);
  }
}
