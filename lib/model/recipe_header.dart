class Recipe {
  int id;
  String name;
  String faceImageUrl;
  int cookTimeMins;
  int prepTimeMins;
  int kilocalories;
  int? proteins;
  int? fats;
  int? carbohydrates;

  Recipe({required this.name, required this.faceImageUrl, required this.id,
  required this.cookTimeMins, required this.prepTimeMins, required this.kilocalories});

}

class Ingredient {
  int id;
  String name;
  String count;

  Ingredient({required this.id, required this.name, required this.count});
}

final List<Recipe> recipes = [
  Recipe(name: "Борщ", faceImageUrl: "assets/images/borsh.jpg", id: 0,
  cookTimeMins: 90, prepTimeMins: 5, kilocalories: 140),
  Recipe(
      name: "Карбонара", faceImageUrl: "assets/images/carbonara.png", id: 1,
  cookTimeMins: 30, prepTimeMins: 0, kilocalories: 320),
  Recipe(name: "Маффины", faceImageUrl: "assets/images/muffin6.jpg", id: 2,
      cookTimeMins: 40, prepTimeMins: 20, kilocalories: 240)
];

final List<Ingredient> borshIngredients = [
  Ingredient(id: 1, name: "Свекла", count: "1 шт."),
  Ingredient(id: 2, name: "Капуста белокочанная", count: "200 г"),
  Ingredient(id: 3, name: "Морковь", count: "50 г"),
  Ingredient(id: 4, name: "Помидоры", count: "1 шт."),
  Ingredient(id: 5, name: "Лук", count: "1 шт.")
];

final List<Ingredient> carbonaraIngredients = [
  Ingredient(id: 1, name: "Бекон", count: "100 г"),
  Ingredient(id: 2, name: "Спагетти", count: "90 г"),
  Ingredient(id: 3, name: "Вода", count: "150 мл"),
  Ingredient(id: 4, name: "Соль", count: "щепотка"),
  Ingredient(id: 5, name: "Яйца куриные", count: "1 шт.")
];

final List<Ingredient> muffinsIngredients = [
  Ingredient(id: 1, name: "Масло сливочное", count: "180 г"),
  Ingredient(id: 2, name: "Шоколад", count: "100 г"),
  Ingredient(id: 3, name: "Сахар", count: "200 г"),
  Ingredient(id: 4, name: "Яйцо", count: "4 шт."),
  Ingredient(id: 5, name: "Мука", count: "100 г"),
  Ingredient(id: 5, name: "Какао", count: "40 г"),
  Ingredient(id: 5, name: "Разрыхлитель", count: "1 ч.л.")
];

final List<List<Ingredient>> ingrResolve = [borshIngredients, carbonaraIngredients,
muffinsIngredients];

class RecipeStep {
  int id;
  String imgUrl;
  String description;

  RecipeStep({required this.id, required this.imgUrl, required this.description});
}

final List<RecipeStep> muffinsSteps = [
  RecipeStep(id: 1, imgUrl: "assets/images/muffin1.jpg", description: "Сливочное масло растопить с шоколадом на водяной бане, немного остудить и слегка взбить миксером. Добавить сахар и опять хорошо взбить."),
  RecipeStep(id: 2, imgUrl: "assets/images/muffin2.jpg", description: "Далее по одному добавляем яйца и после каждого взбиваем массу в течение минуты."),
  RecipeStep(id: 3, imgUrl: "assets/images/muffin3.jpg", description: "В отдельную емкость просеиваем муку, какао и разрыхлитель."),
  RecipeStep(id: 4, imgUrl: "assets/images/muffin4.jpg", description: "Объединяем сухие и жидкие ингредиенты и вымешиваем тесто до однородности."),
  RecipeStep(id: 5, imgUrl: "assets/images/muffin5.jpg", description: "Раскладываем тесто по формочкам (количество теста рассчитано где-то на 12-14 кексиков). Выпекаем шоколадные кексики в разогретой до 180 градусах духовке около 20 минут."),
  RecipeStep(id: 6, imgUrl: "assets/images/muffin6.jpg", description: "Капкейки Брауни готовы. Приятного чаепития!"),
];

final List<List<RecipeStep>> stepsResolve = [[], [], muffinsSteps];
