import 'package:sretnesapice_mobile/models/tag.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class TagProvider extends BaseProvider<Tag> {
  TagProvider() : super("Tags");

  @override
  Tag fromJson(data) {
    return Tag.fromJson(data);
  }
}
