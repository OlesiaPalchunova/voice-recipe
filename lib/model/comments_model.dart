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
    if (rest == 1 && (diff.inMinutes > 20 || diff.inMinutes < 10)) {
      str = "минуту";
    } else if (rest < 5 && rest >= 1 && (diff.inMinutes > 20 || diff.inMinutes < 10)) {
      str = "минуты";
    }
    return "${diff.inMinutes} $str назад";
  }
  if (diff.inHours < 24) {
    if (diff.inHours == 0) {
      return "1 час назад";
    }
    int rest = diff.inHours - ((diff.inHours / 10).floor()) * 10;
    var str = "часов";
    if (rest == 1 && (diff.inHours > 20 || diff.inHours < 10)) {
      str = "час";
    } else if (rest < 5 && rest >= 1 && (diff.inHours > 20 || diff.inHours < 10)) {
      str = "часа";
    }
    return "${diff.inHours} $str назад";
  }
  if (diff.inDays <= 31) {
    if (diff.inDays == 0) {
      return "сегодня";
    }
    int rest = diff.inDays - ((diff.inDays / 10).floor()) * 10;
    var str = "дней";
    if (rest == 1 && (diff.inDays > 20 || diff.inDays < 10)) {
      str = "день";
    } else if (rest < 5 && rest >= 1 && (diff.inDays > 20 || diff.inDays < 10)) {
      str = "дня";
    }
    return "${diff.inHours} $str назад";
  }
  if (diff.inDays > 31) {
    int monthsCount = (diff.inDays / 30).floor();
    int rest = monthsCount - ((monthsCount / 10).floor()) * 10;
    var str = "месяцев";
    if (rest == 1 && (monthsCount > 20 || monthsCount < 10)) {
      str = "месяц";
    } else if (rest < 5 && (monthsCount > 20 || monthsCount < 10)) {
      str = "месяца";
    }
    if (monthsCount == 0) {
      return "30 дней назад";
    }
    return "$monthsCount $str назад";
  }
  return "${diff.inDays} дней назад";
}
