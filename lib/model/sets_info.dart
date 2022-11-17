import 'package:voice_recipe/model/recipes_info.dart';

class RecipesSet {
  final int id;
  final String name;
  final String imageUrl;

  RecipesSet({required this.id, required this.name, required this.imageUrl});
}

final List<RecipesSet> sets = <RecipesSet>[
  RecipesSet(id: 1, name: "По времени", imageUrl: "assets/images/sets/clock.png"),
  RecipesSet(id: 2, name: "Национальные\nкухни", imageUrl: "assets/images/sets/national.png"),
  RecipesSet(id: 3, name: "Премиальные\nрецепты", imageUrl: "assets/images/sets/premium.png"),
  RecipesSet(id: 4, name: "По виду блюда", imageUrl: "assets/images/sets/business_lunch.png"),
];

abstract class SetOption {
  final int id;
  final String name;

  SetOption({required this.id, required this.name});

  List<Recipe> getRecipes();
}

class TimesSetOption extends SetOption {
  final int minimum;
  final int maximum;

  TimesSetOption({required super.id, required super.name, required this.maximum,
  required this.minimum});

  @override
  List<Recipe> getRecipes() {
    return recipes.where((element) {
      var total = element.prepTimeMins + element.cookTimeMins;
      return total >= minimum && total <= maximum;
    }).toList();
  }
}

class StandardSetOption extends SetOption {
  final List<Recipe> options;

  StandardSetOption({required super.id, required super.name, required this.options});

  @override
  List<Recipe> getRecipes() {
    return options;
  }
}


final List<SetOption> timesSetOptions = [
  // TimesSetOption(name: "от 3 до 10 минут", maximum: 10, minimum: 3),
  TimesSetOption(id: 1, name: "от 10 до 25 минут", maximum: 25, minimum: 10),
  TimesSetOption(id: 2, name: "от 25 до 40 минут", maximum: 40, minimum: 25),
  TimesSetOption(id: 3, name: "от 40 минут  до 2 часов", maximum: 120, minimum: 40),
];

final List<SetOption> nationalSetOptions = [
  StandardSetOption(id: 1, name: "Русская кухня", options: [borsh, syrniki]),
  StandardSetOption(id: 2, name: "Итальянская кухня", options: [carbonara]),
  StandardSetOption(id: 3, name: "Американская кухня", options: [muffins]),
  StandardSetOption(id: 4, name: "Азиатская кухня", options: [
    soba, borsh, carbonara, tefts,
    borsh, syrniki, soba, muffins,
    tefts, carbonara, soba, tefts,
    muffins, carbonara, borsh, soba,
    borsh, soba, syrniki, soba,
  ]),
];

final List<SetOption> premiumSetOptions = [
  StandardSetOption(id: 1, name: "Мишлен", options: [syrniki])
];

final List<SetOption> categoriesSetOptions = [
  StandardSetOption(id: 1, name: "Выпечка", options: [muffins, syrniki]),
  StandardSetOption(id: 2, name: "Супы", options: [borsh]),
  StandardSetOption(id: 3, name: "Основные блюда", options: [carbonara, tefts, soba]),
  StandardSetOption(id: 4, name: "Салаты", options: []),
];

final List<List<SetOption>> optionsResolve = [timesSetOptions, nationalSetOptions,
  premiumSetOptions, categoriesSetOptions];
