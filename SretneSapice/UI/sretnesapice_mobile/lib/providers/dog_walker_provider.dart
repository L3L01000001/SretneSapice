import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class DogWalkerProvider extends BaseProvider<DogWalker> {
  DogWalkerProvider() : super("DogWalkers");

  @override
  DogWalker fromJson(data) {
    return DogWalker.fromJson(data);
  }
}
