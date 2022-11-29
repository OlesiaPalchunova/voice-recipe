class UserAccountInfo {
  final int id;
  final String name;
  final String email;
  final String? imageProfileUrl;

  UserAccountInfo({required this.id, required this.name,
    required this.email,
    this.imageProfileUrl = defaultProfileUrl});
}

const String defaultProfileUrl = "https://i.ibb.co/tmxmsTS/profile.png";

List<UserAccountInfo> users = [
  UserAccountInfo(id: 1, name: "Галина XXL", email: ""
      "galinaxxl@mail.ru"),
  UserAccountInfo(id: 2, name: "Генрих Шаманов", email: ""
      "vaccinopower@gmail.com", imageProfileUrl:
  "assets/images/vaccinopower.png")
];
