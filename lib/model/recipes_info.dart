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

int getStepsCount(int recipeId) {
  return stepsResolve[recipeId].length;
}

RecipeStep getStep(int recipeId, int stepId) {
  return stepsResolve[recipeId][stepId];
}

final List<Recipe> recipes = [
  Recipe(name: "Борщ", faceImageUrl: "assets/images/borsh_face.jpg", id: 0,
  cookTimeMins: 90, prepTimeMins: 5, kilocalories: 140),
  Recipe(
      name: "Карбонара", faceImageUrl: "assets/images/carbonara_face.jpg", id: 1,
  cookTimeMins: 30, prepTimeMins: 0, kilocalories: 320),
  Recipe(name: "Маффины", faceImageUrl: "assets/images/muffin6.jpg", id: 2,
      cookTimeMins: 40, prepTimeMins: 20, kilocalories: 240),
  Recipe(name: "Фрикадельки", faceImageUrl: "assets/images/tef4.jpg", id: 3,
      cookTimeMins: 20, prepTimeMins: 0, kilocalories: 440),
  Recipe(name: "Соба с курицей и овощами", faceImageUrl: "assets/images/soba13.jpg", id: 4,
      cookTimeMins: 45, prepTimeMins: 0, kilocalories: 270),
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

final List<Ingredient> tefIngredients = [
  Ingredient(id: 1, name: "Фрикадельки", count: "300 г"),
  Ingredient(id: 2, name: "Томатная паста", count: "100 мл"),
  Ingredient(id: 3, name: "Зелень", count: "50 г"),
  Ingredient(id: 3, name: "Растительное масло", count: "2 ст. л."),
];

final List<Ingredient> sobaIngredients = [
  Ingredient(id: 1, name: "Куриное филе", count: "450 г"),
  Ingredient(id: 2, name: "Болгарский перец", count: "3 шт"),
  Ingredient(id: 3, name: "Гречневая лапша", count: "270 г"),
  Ingredient(id: 3, name: "Морковь", count: "1 шт"),
  Ingredient(id: 3, name: "Лук репчатый", count: "1 шт"),
  Ingredient(id: 3, name: "Зеленый лук", count: "45 г"),
  Ingredient(id: 3, name: "Соевый соус", count: "9 ст. л."),
  Ingredient(id: 3, name: "Растительное масло", count: "4 ст. л."),
];

final List<List<Ingredient>> ingrResolve = [borshIngredients, carbonaraIngredients,
muffinsIngredients, tefIngredients, sobaIngredients];

class RecipeStep {
  int id;
  String imgUrl;
  String description;
  int waitTime;

  RecipeStep({required this.id, required this.imgUrl, required this.description, this.waitTime = 0});

}

final List<RecipeStep> muffinsSteps = [
  RecipeStep(id: 1, imgUrl: "assets/images/muffin1.jpg", description: "Сливочное масло растопить с шоколадом на водяной бане, немного остудить и слегка взбить миксером. Добавить сахар и опять хорошо взбить."),
  RecipeStep(id: 2, imgUrl: "assets/images/muffin2.jpg", description: "Далее по одному добавляем яйца и после каждого взбиваем массу в течение минуты."),
  RecipeStep(id: 3, imgUrl: "assets/images/muffin3.jpg", description: "В отдельную емкость просеиваем муку, какао и разрыхлитель."),
  RecipeStep(id: 4, imgUrl: "assets/images/muffin4.jpg", description: "Объединяем сухие и жидкие ингредиенты и вымешиваем тесто до однородности."),
  RecipeStep(waitTime: 20, id: 5, imgUrl: "assets/images/muffin5.jpg", description: "Раскладываем тесто по формочкам (количество теста рассчитано где-то на 12-14 кексиков). Выпекаем шоколадные кексики в разогретой до 180 градусах духовке около 20 минут."),
  RecipeStep(id: 6, imgUrl: "assets/images/muffin6.jpg", description: "Капкейки Брауни готовы. Приятного чаепития!"),
];

final List<RecipeStep> tefSteps = [
  RecipeStep(waitTime: 10, id: 1, imgUrl: "assets/images/tef1.jpg", description: "Налейте растительное масло в сковородку, разогрейте. Выложите фрикадельки и жарьте в течение 10 минут"),
  RecipeStep(waitTime: 5, id: 2, imgUrl: "assets/images/tef2.jpg", description: "Затем добавьте томатную пасту, залейте кипятком до уровня одного сантиметра. Тушите 5 минут."),
  RecipeStep(id: 3, imgUrl: "assets/images/tef3.jpg", description: "Посыпьте свежей зеленью и подавайте. Приятного аппетита!"),
];

final List<RecipeStep> carbonaraSteps = [
  RecipeStep(id: 1, imgUrl: "assets/images/carbonara1.jpg", description: "Отварить макароны до готовности. Бекон обжарить на сухой сковородке."),
  RecipeStep(id: 2, imgUrl: "assets/images/carbonara2.jpg", description: "Когда бекон немного обжарится, добавить сливки, довести до кипения и убавить огонь. Добавить сыр, постоянно помешивать до растворения сыра. Макароны добавить к сливкам и бекону, перемешать и прогреть 1–2 минуты."),
  RecipeStep(id: 3, imgUrl: "assets/images/carbonara3.jpg", description: "Посыпать черным перцем: все готово!"),
];

final List<RecipeStep> borshSteps = [
  RecipeStep(id: 1, imgUrl: "assets/images/borsh1.jpg", description: "Налейте в кастрюлю холодную воду, выложите мясо и поставьте на средний огонь. Бульон будет вкуснее, если использовать именно мясо на кости."),
  RecipeStep(id: 2, imgUrl: "assets/images/borsh2.jpg", description: "Вымойте и почистите свёклу, морковь и лук. Свёклу натрите на крупной тёрке, а морковь — на средней. Лук нарежьте небольшими кубиками. Налейте масло в сковороду, включите средний огонь. Обжаривайте лук и морковь, помешивая, около 5 минут."),
  RecipeStep(id: 3, imgUrl: "assets/images/borsh3.jpg", description: "Затем выложите свёклу. Добавьте к ней лимонную кислоту, уксус или сок лимона. Благодаря этому борщ будет по-настоящему красным и приобретёт приятную кислинку. Готовьте зажарку ещё 5 минут. После этого добавьте томатную пасту, перемешайте и оставьте на огне ещё на 5–7 минут."),
  RecipeStep(id: 4, imgUrl: "assets/images/borsh4.jpg", description: "Когда бульон сварится, выньте из него мясо. Пока оно остывает, засыпьте в кастрюлю нашинкованную капусту. Через 5–10 минут добавьте нарезанный соломкой или кубиками картофель."),
  RecipeStep(id: 5, imgUrl: "assets/images/borsh5.jpg", description: "Пока варится картофель, отделите мясо от кости и нарежьте кубиками. Верните его в суп. Посолите по вкусу."),
  RecipeStep(id: 6, imgUrl: "assets/images/borsh6.jpg", description: "Для аромата можно добавить в кастрюлю немного измельчённого чеснока, молотой гвоздики или чёрного перца. Оставьте борщ под крышкой настаиваться 5–10 минут."),
];

final List<RecipeStep> sobaSteps = [
  RecipeStep(id: 1, imgUrl: "assets/images/soba1.jpg", description: "Куриное филе можно взять любое, у меня куриная грудка и по этому рецепту она получается совершенно не сухая. Чили можно взять в сушеном виде или просто свежий стручок."),
  RecipeStep(id: 2, imgUrl: "assets/images/soba2.jpg", description: "Налейте в кастрюлю воду, поставьте на средний огонь и доведите до кипения. Немного посолите и опустите лапшу целую, как спагетти, но если так не любите, можно поломать. После повторного закипания варите лапшу примерно 5-7 минут. Она должна быть немного не доваренная. "),
  RecipeStep(id: 3, imgUrl: "assets/images/soba3.jpg", description: "Куриное филе сполосните, обсушите и нарежьте крупной соломкой. В сковороду налейте масло и разогрейте на среднем огне. Добавьте в сковороду курицу и обжарьте в течение 5-7 минут. Снимите сковороду с огня и переложите курицу в чашку."),
  RecipeStep(id: 4, imgUrl: "assets/images/soba4.jpg", description: "Репчатый лук очистите, сполосните и нарежьте полукольцами. Сковороду после курицы возвратите на огонь и положите в нее порезанный лук."),
  RecipeStep(id: 5, imgUrl: "assets/images/soba5.jpg", description: "Морковь почистите, вымойте и нарежьте соломкой средней длины и толщины. Добавьте морковь в сковороду с луком. Перемешайте и обжарьте, перемешивая, в течение 5 минут."),
  RecipeStep(id: 6, imgUrl: "assets/images/soba6.jpg", description: "Болгарский перец вымойте, удалите плодоножку с семенами и нарежьте средней соломкой. Добавьте в сковороду, с обжаренным овощами, перец и перемешайте. Обжарьте в течение 3 минут."),
  RecipeStep(id: 7, imgUrl: "assets/images/soba7.jpg", description: "Верните в сковороду обжаренную курицу и перемешайте."),
  RecipeStep(id: 8, imgUrl: "assets/images/soba8.jpg", description: "Помидор вымойте и вытрете, нарежьте на крупные дольки и добавьте в сковороду с овощами и курицей. Налейте воду и закройте крышкой, уменьшите огонь и готовьте еще 10 минут."),
  RecipeStep(id: 9, imgUrl: "assets/images/soba9.jpg", description: "В миску налейте соевый соус, растительное масло и добавьте перец чили, перемешайте."),
  RecipeStep(id: 10, imgUrl: "assets/images/soba10.jpg", description: "Откройте сковороду и влейте соус, перемешайте."),
  RecipeStep(id: 11, imgUrl: "assets/images/soba11.jpg", description: "Добавьте в сковороду отварную гречневую лапшу и все хорошенько перемешайте, чтобы покрылось соусом."),
  RecipeStep(id: 12, imgUrl: "assets/images/soba12.jpg", description: "Прогрейте лапшу с овощами и курицей на среднем огне в течение 1-2 минут, снимите с огня."),
  RecipeStep(id: 13, imgUrl: "assets/images/soba13.jpg", description: "Наша соба с курицей и овощами готова. Разложите сразу по тарелкам, посыпьте порезанным зеленым луком и подавайте.")
];

final List<List<RecipeStep>> stepsResolve = [borshSteps, carbonaraSteps, muffinsSteps, tefSteps, sobaSteps];
