class UserAccountInfo {
  final int id;
  final String name;
  final String imageProfileUrl;

  UserAccountInfo({required this.id, required this.name,
    this.imageProfileUrl = "assets/images/profile.png"});
}

List<UserAccountInfo> users = [
  UserAccountInfo(id: 1, name: "Галина XXL"),
  UserAccountInfo(id: 2, name: "Генрих Шаманов", imageProfileUrl:
  "assets/images/vaccinopower.png")
];
