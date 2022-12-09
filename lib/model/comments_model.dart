import 'package:voice_recipe/model/users_info.dart';

class Comment {
  final DateTime postTime;
  final String text;
  final String uid;
  final String userName;
  final String profileUrl;

  Comment({
    required this.postTime,
    required this.text,
    required this.uid,
    required this.userName,
    required this.profileUrl
  });
}

String since(DateTime time) {
  var diff = DateTime.now().difference(time);
  if (diff.inMinutes < 60) {
    if (diff.inMinutes == 0) {
      return "только что";
    }
    int rest = diff.inMinutes - ((diff.inMinutes / 10).floor()) * 10;
    var str = "минут";
    if (rest == 1) {
      str = "минуту";
    } else if (rest < 5 && rest >= 1) {
      str = "минуты";
    }
    return "${diff.inMinutes} $str назад";
  }
  if (diff.inDays > 31) {
    int monthsCount = (diff.inDays / 30).floor();
    int rest = monthsCount - ((monthsCount / 10).floor()) * 10;
    var str = "месяцев";
    if (rest == 1) {
      str = "месяц";
    } else if (rest < 5) {
      str = "месяца";
    }
    return "$monthsCount $str назад";
  }
  return "${diff.inDays} дней назад";
}

// final List<Comment> borshReviews = [
//   Comment(postTime: DateTime(2022, DateTime.april), text: "Неплохо!",
//   userName: "Галина Воронина", uid : "voronina"),
//   Comment(postTime: DateTime(2022, DateTime.november), text: "Знаете ли,"
//       "а я еще ботву в конце добавляю, так особенно хорошо получается!",
//   userName: "Генрих Шаманов", profilePhotoURL: "https://i.ibb.co/q1srMLt/vaccinopower.png",
//   uid: "genrikh"),
// ];
//
// final List<List<Comment>> reviews = [
//   borshReviews, [], [], [], [], [], [], [], []
// ];
