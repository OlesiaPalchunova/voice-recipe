import 'package:voice_recipe/model/recipes_info.dart';

class RecipesSet {
  final int id;
  final String name;
  final String imageUrl;

  RecipesSet({required this.id, required this.name, required this.imageUrl});
}

final List<RecipesSet> sets = <RecipesSet>[
  RecipesSet(id: 1, name: "По времени", imageUrl: "assets/images/sets/time.png"),
  RecipesSet(id: 2, name: "Национальные\nкухни", imageUrl: "assets/images/sets/national.png"),
];

abstract class SetOption {
  final String name;

  SetOption({required this.name});

  List<Recipe> getRecipes();
}

class TimesSetOption extends SetOption {
  final int minimum;
  final int maximum;

  TimesSetOption({required super.name, required this.maximum,
  required this.minimum});

  @override
  List<Recipe> getRecipes() {
    return recipes.where((element) {
      var total = element.prepTimeMins + element.cookTimeMins;
      return total >= minimum && total <= maximum;
    }).toList();
  }
}

class NationalSetOption extends SetOption {

  NationalSetOption({required super.name});

  @override
  List<Recipe> getRecipes() {
    return [];
  }
}


final List<SetOption> timesSetOptions = [
  TimesSetOption(name: "от 3 до 10 минут", maximum: 10, minimum: 3),
  TimesSetOption(name: "от 10 до 25 минут", maximum: 25, minimum: 10),
  TimesSetOption(name: "от 25 до 40 минут", maximum: 40, minimum: 25),
];

final List<SetOption> nationalSetOptions = [
  NationalSetOption(name: "Русская кухня"),
  NationalSetOption(name: "Итальянская кухня")
];

final List<List<SetOption>> optionsResolve = [timesSetOptions, nationalSetOptions];
