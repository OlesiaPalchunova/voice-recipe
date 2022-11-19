class Review {
  final int userId;
  final DateTime postTime;
  final String text;

  Review({required this.userId, required this.postTime,
  required this.text});
}

final List<Review> borshReviews = [
  Review(userId: 1, postTime: DateTime(2022, DateTime.april), text: "Неплохо!"),
  Review(userId: 2, postTime: DateTime(2022, DateTime.november), text: "Знаете ли,"
      "а я еще ботву в конце добавляю, так особенно хорошо получается!"),
];

final List<List<Review>> reviews = [
  borshReviews, [], [], [], [], [], []
];
