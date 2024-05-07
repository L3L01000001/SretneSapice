import 'package:sretnesapice_admin/models/role.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super("api/Roles");

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }
}
