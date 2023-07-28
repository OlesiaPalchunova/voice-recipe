class Profile{
  final String uid;
  final String display_name;
  final String? image;
  final String? info;
  final String? tg_link;
  final String? vk_link;

  Profile({
    required this.uid,
    required this.display_name,
    required this.image,
    required this.info,
    required this.tg_link,
    required this.vk_link
  });
}