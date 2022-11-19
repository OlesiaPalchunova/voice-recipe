class User {
  final int id;
  final String name;
  final String imageProfileUrl;

  User({required this.id, required this.name,
    this.imageProfileUrl = "assets/images/profile.png"});
}

final List<User> users = [
  User(id: 1, name: "Галина XXL"),
  User(id: 2, name: "Генрих Шаманов")
];
