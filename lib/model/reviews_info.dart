import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_recipe/model/users_info.dart';

class Review {
  final String profilePhotoURL;
  final String userName;
  final DateTime postTime;
  final String text;

  Review({required this.postTime,
  required this.text, required this.userName, this.profilePhotoURL = defaultProfileUrl});
}

final List<Review> borshReviews = [
  Review(postTime: DateTime(2022, DateTime.april), text: "Неплохо!",
  userName: "Галина XXL"),
  Review(postTime: DateTime(2022, DateTime.november), text: "Знаете ли,"
      "а я еще ботву в конце добавляю, так особенно хорошо получается!",
  userName: "Генрих Шаманов", profilePhotoURL: "assets/images/vaccinopower.png"),
];

final List<List<Review>> reviews = [
  borshReviews, [], [], [], [], [], []
];
