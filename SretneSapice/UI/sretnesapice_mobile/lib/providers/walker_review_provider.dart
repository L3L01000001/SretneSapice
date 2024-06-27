import 'package:sretnesapice_mobile/models/walker_review.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class WalkerReviewProvider extends BaseProvider<WalkerReview> {
  WalkerReviewProvider() : super("WalkerReviews");

  @override
  WalkerReview fromJson(data) {
    return WalkerReview.fromJson(data);
  }
}
