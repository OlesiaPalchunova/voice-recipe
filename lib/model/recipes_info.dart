import 'dart:collection';

import 'package:flutter/cupertino.dart';

class Recipe {
  int id;
  String name;
  String faceImageUrl;
  int cookTimeMins;
  int prepTimeMins;
  double kilocalories;
  int? proteins;
  int? fats;
  int? carbohydrates;
  bool isNetwork;
  List<Ingredient> ingredients;
  List<RecipeStep> steps;

  Recipe({required this.name, required this.faceImageUrl, required this.id,
  required this.cookTimeMins, required this.prepTimeMins, required this.kilocalories,
    required this.ingredients, required this.steps,
    this.isNetwork = false
  });
}

class Ingredient {
  int id;
  String name;
  double count;
  String measureUnit;

  Ingredient({required this.id, required this.name, required this.count, required this.measureUnit});
}

String _imagePath(String name) {
  return "assets/images/$name.jpg";
}

final borsh = Recipe(name: "Борщ", faceImageUrl: _imagePath("borsh_face"), id: 0,
cookTimeMins: 90, prepTimeMins: 5, kilocalories: 140, ingredients: borshIngredients,
steps: borshSteps);
final cutlets = Recipe(name: "Котлеты", faceImageUrl: _imagePath("cutlets10"), id: 1,
    cookTimeMins: 30, prepTimeMins: 0, kilocalories: 450, ingredients: cutletsIngredients,
steps: cutletsSteps);
final muffins = Recipe(name: "Маффины" ,faceImageUrl: _imagePath("muffin6"), id: 2,
cookTimeMins: 40, prepTimeMins: 20, kilocalories: 240, ingredients: muffinsIngredients,
steps: muffinsSteps);
final tefts = Recipe(name: "Фрикадельки", faceImageUrl: _imagePath("tef5"), id: 3,
cookTimeMins: 20, prepTimeMins: 0, kilocalories: 440, ingredients: tefIngredients,
steps: tefSteps);
final soba = Recipe(name: "Соба с курицей и овощами", faceImageUrl: _imagePath("soba13"), id: 4,
cookTimeMins: 45, prepTimeMins: 0, kilocalories: 270, ingredients: sobaIngredients,
steps: sobaSteps);
final syrniki = Recipe(name: "Сырники", faceImageUrl: _imagePath("syrniki5"), id: 5,
cookTimeMins: 30, prepTimeMins: 0, kilocalories: 340, ingredients: syrnikiIngredients,
steps: syrnikiSteps);
final carbonara = Recipe(
    name: "Карбонара",faceImageUrl: _imagePath("carbonara_face"), id: 6,
    cookTimeMins: 30, prepTimeMins: 0, kilocalories: 320,
ingredients: carbonaraIngredients, steps: carbonaraSteps);

final List<Recipe> recipes = [
  borsh, cutlets, muffins, tefts, soba, syrniki, carbonara
];

final List<Ingredient> borshIngredients = [
  Ingredient(id: 1, name: "Свекла", measureUnit: "шт.", count: 1),
  Ingredient(id: 2, name: "Капуста белокочанная", measureUnit: "г", count: 200),
  Ingredient(id: 3, name: "Морковь", measureUnit: "г", count: 50),
  Ingredient(id: 4, name: "Помидоры", measureUnit: "шт.", count: 1),
  Ingredient(id: 5, name: "Лук", measureUnit: "шт.", count: 1)
];

final List<Ingredient> cutletsIngredients = [
  Ingredient(id: 1, name: "Фарш куриный", measureUnit: "г.", count: 450),
  Ingredient(id: 2, name: "Хлеб черный", measureUnit: "ломтика", count: 4),
  Ingredient(id: 3, name: "Хмели-сунели", measureUnit: "ч.л.", count: 2),
  Ingredient(id: 4, name: "Яйцо", measureUnit: "шт.", count: 1),
  Ingredient(id: 5, name: "Лук", measureUnit: "шт.", count: 1),
  Ingredient(id: 5, name: "Молоко", measureUnit: "мл.", count: 100),
  Ingredient(id: 5, name: "Зелень", measureUnit: "г.", count: 50),
];

final List<Ingredient> muffinsIngredients = [
  Ingredient(id: 1, name: "Масло сливочное", measureUnit: "г", count: 180),
  Ingredient(id: 2, name: "Шоколад", measureUnit: "г", count: 100),
  Ingredient(id: 3, name: "Сахар", measureUnit: "г", count: 200),
  Ingredient(id: 4, name: "Яйцо", measureUnit: "шт.", count: 4),
  Ingredient(id: 5, name: "Мука", measureUnit: "г", count: 100),
  Ingredient(id: 5, name: "Какао", measureUnit: "г", count: 40),
  Ingredient(id: 5, name: "Разрыхлитель", measureUnit: "ч.л.", count: 1)
];

final List<Ingredient> tefIngredients = [
  Ingredient(id: 1, name: "Фрикадельки", measureUnit: "г", count: 300),
  Ingredient(id: 2, name: "Томатная паста", measureUnit: "мл", count: 100),
  Ingredient(id: 3, name: "Зелень", measureUnit: "г", count: 50),
  Ingredient(id: 3, name: "Растительное масло", measureUnit: "ст. л.", count: 2),
];

final List<Ingredient> sobaIngredients = [
  Ingredient(id: 1, name: "Куриное филе", measureUnit: "г", count: 450),
  Ingredient(id: 2, name: "Болгарский перец", measureUnit: "шт", count: 3),
  Ingredient(id: 3, name: "Гречневая лапша", measureUnit: "г", count: 270),
  Ingredient(id: 3, name: "Морковь", measureUnit: "шт", count: 1),
  Ingredient(id: 3, name: "Помидор", measureUnit: "шт", count: 1),
  Ingredient(id: 3, name: "Лук репчатый", measureUnit: "шт", count: 1),
  Ingredient(id: 3, name: "Зеленый лук", measureUnit: "г", count: 45),
  Ingredient(id: 3, name: "Соевый соус", measureUnit: "ст. л.", count: 9),
  Ingredient(id: 3, name: "Растительное масло", measureUnit: "ст. л.", count: 4),
];

final List<Ingredient> syrnikiIngredients = [
  Ingredient(id: 1, name: "Творог", measureUnit: "г", count: 450),
  Ingredient(id: 2, name: "Ванилин", measureUnit: "г", count: 2),
  Ingredient(id: 3, name: "Манная крупа", measureUnit: "ст. л.", count: 1.5),
  Ingredient(id: 4, name: "Яйцо", measureUnit: "шт.", count: 1),
  Ingredient(id: 5, name: "Соль", measureUnit: "щепотка", count: 1),
  Ingredient(id: 5, name: "Сахар", measureUnit: "ст. л.", count: 3),
];

final List<Ingredient> carbonaraIngredients = [
  Ingredient(id: 1, name: "Бекон", measureUnit: "г", count: 100),
  Ingredient(id: 2, name: "Спагетти", measureUnit: "г", count: 90),
  Ingredient(id: 3, name: "Вода", measureUnit: "мл", count: 150),
  Ingredient(id: 4, name: "Соль", measureUnit: "щепотка", count: 1),
  Ingredient(id: 5, name: "Яйца куриные", measureUnit: "шт.", count: 1),
  Ingredient(id: 5, name: "Сыр", measureUnit: "г.", count: 100),
  Ingredient(id: 5, name: "Сливки", measureUnit: "мл.", count: 50),
];

class RecipeStep {
  int id;
  String imgUrl;
  String description;
  int waitTime;

  RecipeStep({required this.id, required this.imgUrl, required this.description, this.waitTime = 0});

}

final List<RecipeStep> muffinsSteps = [
  RecipeStep(id: 1, imgUrl: _imagePath("muffin1"), description: "Сливочное масло растопить с шоколадом на водяной бане, немного остудить и слегка взбить миксером. Добавить сахар и опять хорошо взбить."),
  RecipeStep(id: 2, imgUrl: _imagePath("muffin2"), description: "Далее по одному добавляем яйца и после каждого взбиваем массу в течение минуты."),
  RecipeStep(id: 3, imgUrl: _imagePath("muffin3"), description: "В отдельную емкость просеиваем муку, какао и разрыхлитель."),
  RecipeStep(id: 4, imgUrl: _imagePath("muffin4"), description: "Объединяем сухие и жидкие ингредиенты и вымешиваем тесто до однородности."),
  RecipeStep(waitTime: 20, id: 5, imgUrl: _imagePath("muffin5"), description: "Раскладываем тесто по формочкам (количество теста рассчитано где-то на 12-14 кексиков). Выпекаем шоколадные кексики в разогретой до 180 градусах духовке около 20 минут."),
  RecipeStep(id: 6, imgUrl: _imagePath("muffin6"), description: "Капкейки Брауни готовы. Приятного чаепития!"),
];

final List<RecipeStep> tefSteps = [
  RecipeStep(waitTime: 10, id: 1, imgUrl: _imagePath("tef1"), description: "Налейте растительное масло в сковородку, разогрейте. Выложите фрикадельки и жарьте в течение 10 минут"),
  RecipeStep(waitTime: 5, id: 2, imgUrl: _imagePath("tef2"), description: "Затем добавьте томатную пасту, залейте кипятком до уровня одного сантиметра. Тушите 5 минут."),
  RecipeStep(id: 3, imgUrl: _imagePath("tef3"), description: "Посыпьте свежей зеленью и подавайте. Приятного аппетита!"),
];

final List<RecipeStep> carbonaraSteps = [
  RecipeStep(waitTime: 1, id: 1, imgUrl: _imagePath("carbonara1"), description: "Отварить макароны до готовности. Бекон обжарить на сухой сковородке."),
  RecipeStep(id: 2, imgUrl: _imagePath("carbonara2"), description: "Когда бекон немного обжарится, добавить сливки, довести до кипения и убавить огонь. Добавить сыр, постоянно помешивать до растворения сыра. Макароны добавить к сливкам и бекону, перемешать и прогреть 1–2 минуты."),
  RecipeStep(id: 3, imgUrl: _imagePath("carbonara3"), description: "Посыпать черным перцем: все готово!"),
];

final List<RecipeStep> borshSteps = [
  RecipeStep(waitTime: 90, id: 1, imgUrl: _imagePath("borsh1"), description: "Налейте в кастрюлю холодную воду, выложите мясо и поставьте на средний огонь. Бульон будет вкуснее, если использовать именно мясо на кости."),
  RecipeStep(waitTime: 5, id: 2, imgUrl: _imagePath("borsh2"), description: "Вымойте и почистите свёклу, морковь и лук. Свёклу натрите на крупной тёрке, а морковь — на средней. Лук нарежьте небольшими кубиками. Налейте масло в сковороду, включите средний огонь. Обжаривайте лук и морковь, помешивая, около 5 минут."),
  RecipeStep(waitTime: 7, id: 3, imgUrl: _imagePath("borsh3"), description: "Затем выложите свёклу. Добавьте к ней лимонную кислоту, уксус или сок лимона. Благодаря этому борщ будет по-настоящему красным и приобретёт приятную кислинку. Готовьте зажарку ещё 5 минут. После этого добавьте томатную пасту, перемешайте и оставьте на огне ещё на 5–7 минут. Вместо томатной пасты можете добавить свежие, предварительно их нарезав мелкими кубиками, будет достаточно одного томата."),
  RecipeStep(waitTime: 10, id: 4, imgUrl: _imagePath("borsh4"), description: "Когда бульон сварится, выньте из него мясо. Пока оно остывает, засыпьте в кастрюлю нашинкованную капусту. Через 5–10 минут добавьте нарезанный соломкой или кубиками картофель."),
  RecipeStep(id: 5, imgUrl: _imagePath("borsh5"), description: "Пока варится картофель, отделите мясо от кости и нарежьте кубиками. Верните его в суп. Посолите по вкусу."),
  RecipeStep(waitTime: 10, id: 6, imgUrl: _imagePath("borsh6"), description: "Для аромата можно добавить в кастрюлю немного измельчённого чеснока, молотой гвоздики или чёрного перца. Оставьте борщ под крышкой настаиваться 5–10 минут."),
];

final List<RecipeStep> sobaSteps = [
  RecipeStep(id: 1, imgUrl: _imagePath("soba1"), description: "Куриное филе можно взять любое, у меня куриная грудка и по этому рецепту она получается совершенно не сухая. Чили можно взять в сушеном виде или просто свежий стручок."),
  RecipeStep(waitTime: 3, id: 2, imgUrl: _imagePath("soba2"), description: "Налейте в кастрюлю воду, поставьте на средний огонь и доведите до кипения. Немного посолите и опустите лапшу целую, как спагетти, но если так не любите, можно поломать. После повторного закипания варите лапшу примерно 5-7 минут. Она должна быть немного не доваренная. "),
  RecipeStep(waitTime: 7, id: 3, imgUrl: _imagePath("soba3"), description: "Куриное филе сполосните, обсушите и нарежьте крупной соломкой. В сковороду налейте масло и разогрейте на среднем огне. Добавьте в сковороду курицу и обжарьте в течение 5-7 минут. Снимите сковороду с огня и переложите курицу в чашку."),
  RecipeStep(id: 4, imgUrl: _imagePath("soba4"), description: "Репчатый лук очистите, сполосните и нарежьте полукольцами. Сковороду после курицы возвратите на огонь и положите в нее порезанный лук."),
  RecipeStep(waitTime: 5, id: 5, imgUrl: _imagePath("soba5"), description: "Морковь почистите, вымойте и нарежьте соломкой средней длины и толщины. Добавьте морковь в сковороду с луком. Перемешайте и обжарьте, перемешивая, в течение 5 минут."),
  RecipeStep(waitTime: 3, id: 6, imgUrl: _imagePath("soba6"), description: "Болгарский перец вымойте, удалите плодоножку с семенами и нарежьте средней соломкой. Добавьте в сковороду, с обжаренным овощами, перец и перемешайте. Обжарьте в течение 3 минут."),
  RecipeStep(id: 7, imgUrl: _imagePath("soba7"), description: "Верните в сковороду обжаренную курицу и перемешайте."),
  RecipeStep(waitTime: 10, id: 8, imgUrl: _imagePath("soba8"), description: "Помидор вымойте и вытрете, нарежьте на крупные дольки и добавьте в сковороду с овощами и курицей. Налейте воду и закройте крышкой, уменьшите огонь и готовьте еще 10 минут."),
  RecipeStep(id: 9, imgUrl: _imagePath("soba9"), description: "В миску налейте соевый соус, растительное масло и добавьте перец чили, перемешайте."),
  RecipeStep(id: 10, imgUrl: _imagePath("soba10"), description: "Откройте сковороду и влейте соус, перемешайте."),
  RecipeStep(id: 11, imgUrl: _imagePath("soba11"), description: "Добавьте в сковороду отварную гречневую лапшу и все хорошенько перемешайте, чтобы покрылось соусом."),
  RecipeStep(waitTime: 2, id: 12, imgUrl: _imagePath("soba12"), description: "Прогрейте лапшу с овощами и курицей на среднем огне в течение 1-2 минут, снимите с огня."),
  RecipeStep(id: 13, imgUrl: _imagePath("soba13"), description: "Наша соба с курицей и овощами готова. Разложите сразу по тарелкам, посыпьте порезанным зеленым луком и подавайте.")
];

final List<RecipeStep> syrnikiSteps = [
  RecipeStep(id: 1, imgUrl: _imagePath("syrniki1"), description: "Переложите всё в миску."),
  RecipeStep(waitTime: 20, id: 2, imgUrl: _imagePath("syrniki2"), description: "Доведите до однородной консистенции блендером, миксером или тем, что у вас есть (можно разминать эту массу вилкой минут 20, а потом ещё руками 3 минуты давить тесто)."),
  RecipeStep(waitTime: 120, id: 3, imgUrl: _imagePath("syrniki3"), description: "Накрываем миску пищевой плёнкой или помещаем в целлофановый пакет и ставим в холодильник, желательно, на ночь, но можно и на 2-3 часа."),
  RecipeStep(id: 4, imgUrl: _imagePath("syrniki4"), description: "Достаём и рукой формируем сырники, как душа пожелает."),
  RecipeStep(id: 5, imgUrl: _imagePath("syrniki5"), description: "Получается очень вкусно, можно подавать со сметаной и угощать друзей!"),
];

final List<RecipeStep> cutletsSteps = [
  RecipeStep(id: 1, imgUrl: _imagePath("cutlets1"), description: "Подготовьте ингредиенты."),
  RecipeStep(id: 2, imgUrl: _imagePath("cutlets2"), description: "Нарежьте лук мелко, чтобы он в дальнейшем хорошо прожарился и не хрустел"),
  RecipeStep(id: 3, imgUrl: _imagePath("cutlets3"), description: "Возьмите ломтики хлеба и вырежьте из них центр. Получившиеся прямоугольники из корочки можно сохранить и потом приготовить с ними яичницу."),
  RecipeStep(id: 4, imgUrl: _imagePath("cutlets4"), description: "Нарежьте хлеб небольшими кубиками, как показано на слайде."),
  RecipeStep(waitTime: 5, id: 5, imgUrl: _imagePath("cutlets5"), description: "Переложите в небольшую ёмкость и залейте молоком, ожидайте в течение 5 минут."),
  RecipeStep(id: 6, imgUrl: _imagePath("cutlets6"), description: "Затем подготовьте зелень."),
  RecipeStep(id: 7, imgUrl: _imagePath("cutlets7"), description: "Подготовьте небольшую посуду с мукой, чтобы обвалять в ней котлеты, однако это необязательно."),
  RecipeStep(id: 8, imgUrl: _imagePath("cutlets8"), description: "Сложите вместе лук, зелень, яйцо, хлеб, приправу и соль, тщательно перемешайте и сформируйте котлеты. Желательная толщина: 1,5 - 2 см."),
  RecipeStep(id: 9, imgUrl: _imagePath("cutlets9"), description: "Жарьте с каждой стороны на среднем огне по 6 минут", waitTime: 12),
  RecipeStep(id: 10, imgUrl: _imagePath("cutlets10"), description: "Готово. Приятного аппетита :)"),
];

class Rate {

}

final ratesMap = HashMap<int, int>();

final List<double> rates = [
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
  4.1, 4.7, 4.0, 4.2, 4.4, 4.9, 4.3,
];
