class RecipesSet {
  final int id;
  final String name;
  final String imageUrl;

  RecipesSet({required this.id, required this.name, required this.imageUrl});
}

final List<RecipesSet> sets = <RecipesSet>[
  RecipesSet(id: 1, name: "По времени", imageUrl: "assets/images/sets/time.png")
];
