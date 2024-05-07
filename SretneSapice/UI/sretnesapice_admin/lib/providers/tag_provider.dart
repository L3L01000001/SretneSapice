import 'package:sretnesapice_admin/models/tag.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class TagProvider extends BaseProvider<Tag> {
  TagProvider() : super("Tags");

  @override
  Tag fromJson(data) {
    return Tag.fromJson(data);
  }
}
