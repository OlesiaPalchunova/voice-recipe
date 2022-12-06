import 'package:voice_recipe/model/users_info.dart';

class Comment {
  final String profilePhotoURL;
  final String userName;
  final DateTime postTime;
  final String text;

  Comment({required this.postTime,
  required this.text, required this.userName, this.profilePhotoURL = defaultProfileUrl});
}

final List<Comment> borshReviews = [
  Comment(postTime: DateTime(2022, DateTime.april), text: "Неплохо!",
  userName: "Галина Воронина"),
  Comment(postTime: DateTime(2022, DateTime.november), text: "Знаете ли,"
      "а я еще ботву в конце добавляю, так особенно хорошо получается!",
  userName: "Генрих Шаманов", profilePhotoURL: "https://i.ibb.co/q1srMLt/vaccinopower.png"),
];

final List<List<Comment>> reviews = [
  borshReviews, [], [], [], [], [], []
];
