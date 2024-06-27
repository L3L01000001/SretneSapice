import 'package:sretnesapice_mobile/models/favorite_walker.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class FavoriteWalkerProvider extends BaseProvider<FavoriteWalker> {
  FavoriteWalkerProvider() : super("FavoriteWalkers");

  @override
  FavoriteWalker fromJson(data) {
    return FavoriteWalker.fromJson(data);
  }
}
