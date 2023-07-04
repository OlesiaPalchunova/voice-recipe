import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/recipes_sender.dart';
import 'package:voice_recipe/model/recipes_info.dart';

class CookPadParser {
  CookPadParser._internal();

  factory CookPadParser() {
    return CookPadParser._internal();
  }

  String extractRecipeName(String fullName) {
    for (int i = 0; i < fullName.length; i++) {
      if (fullName
          .substring(i)
          .startsWith(RegExp(r'("Recipe by")|(Автор рецепта)'))) {
        return fullName.substring(0, i).trim();
      }
    }
    return fullName.trim();
  }

  int? getWaitTime(String desc) {
    final hourRegExp = RegExp(r'\d+ час');
    final minsRegExp = RegExp(r'\d+ мин');
    if (desc.contains('1,5 часа')) {
      return 90;
    } 
    if (desc.contains(hourRegExp)) {
      String? hourText = hourRegExp.allMatches(desc).first.group(0);
      if (hourText != null) {
        int? res = int.tryParse(hourText.split(' ').first);
        if (res == null) {
          return null;
        }
        return res * 60;
      }
    }
    if (desc.contains('получаса') || desc.contains('полчаса')) {
      return 30;
    }
    if (desc.contains(' часа ')) {
      return 60;
    }
    if (!desc.contains(minsRegExp)) {
      return null;
    }
    String? minsText = minsRegExp.allMatches(desc).first.group(0);
    if (minsText != null) {
      int? res = int.tryParse(minsText.split(' ').first);
      if (res == null) {
        return null;
      }
      return res;
    }
    return null;
  }

  List<RecipeStep> getSteps(Document document) {
    List<RecipeStep> recipeSteps = [];
    var steps = document.getElementsByClassName("step mb-rg");
    int count = 0;
    for (var step in steps) {
      final regExp = RegExp(r"(Step|Шаг) \d+");
      String desc =
          step.text.replaceAll('\n', '').replaceAll(regExp, ' ').trim();
      String stepImageUrl = "default";
      for (var child in step.children) {
        for (var grandchild in child.children) {
          String? imageId = grandchild.attributes["href"];
          if (imageId == null) {
            continue; //        /ru/step_attachment/images/3869c4519b6b5998
          }
          String id = imageId.substring("/ru/step_attachment/images/".length);
          stepImageUrl =
              "https://img-global.cpcdn.com/steps/$id/640x640sq70/photo.jpg";
        }
      }
      int? waitTimeMins = getWaitTime(desc);
      recipeSteps.add(RecipeStep(
          id: count,
          waitTime: waitTimeMins?? 0,
          imgUrl: stepImageUrl,
          description: desc,
          hasImage: stepImageUrl != "default"));
      count++;
    }
    return recipeSteps;
  }

  List<Ingredient> getIngredients(Document document) {
    var ings = document.getElementsByClassName("ingredient-list");
    final numRegExp = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");
    var counts = ings.first.getElementsByClassName("font-semibold").map((c) => c.text.trim()).where(
      (c) => c.startsWith(numRegExp)
    ).toList();
    var toIgnore = ings.first.getElementsByClassName("font-semibold").map((c) => c.text.trim()).where(
      (c) => !c.startsWith(numRegExp) && c.isNotEmpty
    ).toList();
    String ingsText = ings.first.text.trim();
    List<String> rawIngsLabels = ingsText.replaceAll('\n', '@').split('@');
    List<String> ingsLabels = rawIngsLabels
        .map((e) => e.trim())
        .where((n) {
          if (n.isEmpty) return false;
          if (n.endsWith(':')) return false;
          bool ignore = false;
          for (var ign in toIgnore) {
            if (n.startsWith(ign)) {
              return false;
            } 
          }
          return true;
        })
        .toList();
    // print(counts);
    // print(ingsLabels);
    // print(toIgnore);
    final rangeRegExp = RegExp(r'\d+-\d+');
    counts = counts.map(
      (c) {
        c = c.replaceAll('1/2', '0.5');
        if (c.startsWith(rangeRegExp)) {
          String numText = c.split('-').first;
          return c.replaceAll(rangeRegExp, numText);
        }
        return c;
      }
    ).toList();
    List<String> clearedIngsList = [];
    for (int i = 0; i < ingsLabels.length; i++) {
      String cleared;
      ingsLabels[i] = ingsLabels[i].replaceAll(rangeRegExp, "").replaceAll('1/2', '0.5');
      if (i >= counts.length) {
        cleared = ingsLabels[i];
      } else {
        var words = counts[i].split(' ');
        for (var word in words) {
          ingsLabels[i] = ingsLabels[i].replaceAll(word, "");
        }
        cleared = ingsLabels[i].replaceFirst(counts[i], "").trim();
      }
      clearedIngsList.add(cleared);
    }
    List<Ingredient> ingredients = [];
    for (int i = 0; i < ingsLabels.length; i++) {
      String countText;
      if (i < counts.length) {
        countText = counts[i];
      } else {
        countText = "1 ед.";
      }
      double count = 1;
      if (countText.startsWith(numRegExp)) {
        String numText = countText.split(' ').first;
        double? newCount = double.tryParse(numText);
        if (newCount != null) {
          count = newCount;
        }
      }
      String measureUnit = countText.replaceFirst(numRegExp, '').trim();
      if (measureUnit.isEmpty) {
        measureUnit = "ед.";
      }
      String name = clearedIngsList[i];
      ingredients.add(Ingredient(
          id: i, name: name, count: count, measureUnit: measureUnit));
    }
    List<Ingredient> res = [];
    for (var ing in ingredients) {
      bool contains = false;
      for (int i = 0; i < res.length; i++) {
        if (ing.name == res[i].name) {
          res[i].count += ing.count;
          contains = true;
        }
      }
      if (!contains) {
        res.add(ing);
      }
    }
    // for (var ing in ingredients) {
    //   print("${ing.name}\n${ing.count}\n${ing.measureUnit}\n===");
    // }
    // for (var ing in res) {
    //   print("${ing.name}\n${ing.count}\n${ing.measureUnit}\n===");
    // }
    return res;
  }

  bool isRussian(String text) {
    final cyrillicPattern = RegExp(r"[^а-яА-Я]");
    if (text.isEmpty) {
      return false;
    }
    return !cyrillicPattern.hasMatch(text.substring(0, 1));
  }

  static int forbidInRowCount = 0;

  Future<Recipe?> getRecipe(int id, Mode mode) async {
    http.Response response = await fetchRecipe(id, mode);
    if (response.statusCode != 200) {
      print("[PARSER] ${response.statusCode}");
      if (response.statusCode == 403) {
        forbidInRowCount++;
        sleep(const Duration(seconds: 20));
        if (forbidInRowCount >= 10) {
          exit(1);
        }
      } else {
        forbidInRowCount = 0;
      }
      return null;
    } else {
      forbidInRowCount = 0;
    }
    Document document = parse(response.body);
    var head = document.getElementsByTagName("head");
    var title = head.first.getElementsByTagName("title");
    String fullName = title.first.text;
    Element? timeElement = document.getElementById("cooking_time_recipe_$id");
    int cookTimeMins = 30;
    if (timeElement != null) {
      var words = timeElement.text.trim().split(' ');
      if (words.length == 2) {
        String timeText = words.first;
        int? newCookTimeMins = int.tryParse(timeText);
        if (newCookTimeMins != null) {
          cookTimeMins = newCookTimeMins;
          if (words.last == "час") {
            cookTimeMins *= 60;
          }
        }
      } else if (words.length == 4) {
        String hourText = words[0];
        int? hours = int.tryParse(hourText);
        String minText = words[2];
        int? mins = int.tryParse(minText);
        if (mins != null && hours != null) {
          cookTimeMins = mins + hours * 60;
        }
      }
    }
    String name = extractRecipeName(fullName);
    if (!isRussian(name)) {
      // print('not russian - $name');
      return null;
    } else {
      print('[PARSER] russian : $name');
    }
    List<Ingredient> ingredients = getIngredients(document);
    List<RecipeStep> steps = getSteps(document);
    var recipeImage = document.getElementById("recipe_image");
    String? faceImageId = recipeImage?.nodes.last.attributes["href"]
        ?.substring("/ru/recipe/images/".length);
    if (faceImageId == null) {
      print("[PARSER] no face image");
      return null;
    }
    String faceImageUrl =
        "https://img-global.cpcdn.com/recipes/$faceImageId/1280x1280sq70/photo.jpg";
    for (int i = 0; i < name.length; i++) {
      if (name.substring(i).startsWith("- пошаговый")) {
        name = name.substring(0, i).trim();
        break;
      }
    }
    Recipe result = Recipe(
        name: name,
        faceImageUrl: faceImageUrl,
        id: id,
        cookTimeMins: cookTimeMins,
        prepTimeMins: 0,
        kilocalories: 0,
        ingredients: ingredients,
        steps: steps);
    return result;
  }

  Future<http.Response> fetchRecipe(int id, Mode mode) async {
    if (mode == Mode.chrome) {
      return fetchRecipeChrome(id);
    }
    if (mode == Mode.brave) {
      return fetchRecipeBrave(id);
    }
    return fetchRecipeEdge(id);
  }

  Future<http.Response> fetchRecipeEdge(int id) async {
    var recipeUrl = Uri.parse('https://cookpad.com/ru/recipes/$id');
    return http.get(recipeUrl, headers: {
      "authority": "cookpad.com",
      "method": "GET",
      "path": "/ru/recipes/$id",
      "scheme": "https",
      "accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "ru,en;q=0.9,en-GB;q=0.8,en-US;q=0.7",
      "cookie":
          "ab_session=0.09455792200833035; f_unique_id=a254f1a4-a282-4ef2-91aa-8c87b838c727; pxcts=01248309-9700-11ed-b1d6-4b556b4e4f49; _pxvid=005eee33-9700-11ed-b807-7551434f5756; seen_bookmark_reminder=true; access_token_global=eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqTTBaakk1Wm1Fek4yWXlNekZrTjJJeFpXSXpNelU0T0dWa01UQXdNRFk0Tm1SbE5UUmxOVFUwWXpRMk1qSXpNV1ZtT0RrMU5EZGlZVEkwTlRNellUWWkiLCJleHAiOm51bGwsInB1ciI6ImNvb2tpZS5hY2Nlc3NfdG9rZW5fZ2xvYmFsIn19--08b1c233c982a3b6b407e6be17b7e74bb68ea6a8; keyword_history_en=%5B%7B%22query%22%3A%22russian%22%2C%22type%22%3A%22recipe%22%7D%5D; recipe_view_count_en=16; _pxff_ne=1; _pxhd=B/yxqvd8Cxag5k27iUV2DVbA1fmJTzYMNROxBfAGmXYrRgG/gKlxMZ1R/hB1UQCc296YLzvOfTZgH2zzCiP/7w==:wRAkyc/HXeVnwXyCC3TciFg/fRROfC4q6EWuygsYXcgml8uqCktGRUICh2cI05CbJWuzVVoIW2sKflZ7l8Q-YrO563qvUyFWoHcUNnOPZ8k=; _pxff_cc=U2FtZVNpdGU9TGF4Ow==; recipe_view_count_ru=39; _global_web_session=4C1nS2ilrpIcyXvsi2m9mzQDo0hN01tp72jBv5xjJjMFDtBP%2F%2FVdmg7j6b%2BIrJ5sw7jwdEct7sUBmXaUJVC2ciT34QFVHxI9ucescEdRzHszh9bVeNQv1ZzKFTb2Eg1%2BIt3%2Fm%2F9CGvu1YH0YkGuixZQy6eDxcY%2BwLLuLf0YTCLl24obEUkGHv5YT5FtezfJbwxzgqbnVUKKMysSpw4QXMQF0Q3lQGt6gdMQ%2BltsDK5u0Cab4pcoPgoyzxTfarQK%2FULC9oY4FjwmyBneZRI6ljYaGROtwHWq%2BiFuuOSWsTRZzC3OQptYNbbH8lfcGrsaT4NAVCF5N3IZQaqHobmgy--nFvsJQ0twOy1WOF4--mIzxl03H6RfzWSndJwFDug%3D%3D; _px2=eyJ1IjoiZmRhNWMwODAtOTdkNS0xMWVkLWIzODctOGJhYzhlYWQzNWNjIiwidiI6IjAwNWVlZTMzLTk3MDAtMTFlZC1iODA3LTc1NTE0MzRmNTc1NiIsInQiOjE2NzQxMTg0MDI0MDcsImgiOiIxZTM3OTEyNThhOTcxMzY3MzhiNjhkNGJlZGE2NjRkMDMzZTEwYTBjMzUwZWE2Y2NkYWRiODVhNWZjY2M3OWNiIn0=",
      "sec-ch-ua":
          ''''"Not_A Brand";v="99", "Microsoft Edge";v="109", "Chromium";v="109"''',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "Windows",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0"
    });
  }

  Future<http.Response> fetchRecipeChrome(int id) async {
    var recipeUrl = Uri.parse('https://cookpad.com/ru/recipes/$id');
    return http.get(recipeUrl, headers: {
      "authority": "cookpad.com",
      "method": "GET",
      "path": "/ru/recipes/$id",
      "scheme": "https",
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "ru,en;q=0.9,en-GB;q=0.8,en-US;q=0.7",
      "cookie":
          "ab_session=0.9044959719048965; f_unique_id=b7fd2f48-48bc-40e6-aa35-f5660805cbea; _pxvid=7f53572c-97f1-11ed-9c35-564e42514c6c; _ga=GA1.2.1245039347.1674129901; _gid=GA1.2.1610292391.1674129901; seen_bookmark_reminder=true; recipe_view_count_id=1; recipe_view_count_es=9; recipe_view_count_fr=2; recipe_view_count_hi=1; _ym_uid=1674202831464027743; _ym_d=1674202831; _ym_isad=2; pxcts=4e3fc63d-989b-11ed-9997-736e78725178; _ym_visorc=b; access_token_global=eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqTXlPREF6Wm1FME1HRTNNREZrTkdNMFlUWTBNV1ZqWmpRME1qVmlOemd6TlRKbFpEVTVNak0wT0Rkak16QXpaRFEzTlRVM016Tm1Oakk0WldJNE9URWkiLCJleHAiOm51bGwsInB1ciI6ImNvb2tpZS5hY2Nlc3NfdG9rZW5fZ2xvYmFsIn19--11c2a1801f5c27fe2dcb9cfe4accf3312670725d; _pxff_ne=1; recipe_view_count_ru=3; _pxhd=YBKfR76DqpSlqk8yHYnhNR-J7uwV8rS/qbP2nKfXoc8zsXSlwg04NGLrIJ6jLFlYc-vvW8apTRzr3VcsT4X5qA==:kT4l71N9tvfoONhPLF4C1g/eWgi66I7H2lxjXEYK5PYbmslnYCl9hB1Sf22amHp0ThjJqzDplxoqjlcRJGPZpCNH6zgH386ltOvnGiUTAts=; _global_web_session=28GPLQMsyiXLgOBHrbau3%2FjBbh0JOspYbLt%2Bs83PFBdYj96Fxye2ShT5bm3nA%2BJGW%2FO6Leui7SvNwAjkbnBX0lOeClRS9eDWIXbwgSejUnEgKfdHrVO7Oc1a%2BKNca3O4YxOHkiAClQGRAeB094GUn%2BgQQfRpZqiRrYDP8j6YgNqoXfBLgglkhA4eGdFOrEK2%2B4FgHNSqEyUq7tU1AXucYw3lc7jCCYLGtO554kk0EOUVw5GRZ6U9027XEH72ibAEv%2F6wafSffDUHik41XtmWxRblgkx4hYJzY%2Fc3gSLOt0e9cE1Y15mLV5O9ATJulXYdzyDGLjo%2FV7n1Nxd4sgJr--br4MNcnNfry%2Fd4mt--KahoFFe3EtR2B4Lv3HkYkg%3D%3D",
      "sec-ch-ua":
          ''''"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"''',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "Windows",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
    });
  }

  Future<http.Response> fetchRecipeBrave(int id) async {
    var recipeUrl = Uri.parse('https://cookpad.com/ru/recipes/$id');
    return http.get(recipeUrl, headers: {
      "authority": "cookpad.com",
      "method": "GET",
      "path": "/ru/recipes/$id",
      "scheme": "https",
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "ru,en;q=0.9,en-GB;q=0.8,en-US;q=0.7",
      "cookie":
          "ab_session=0.955698077160413; f_unique_id=eec4f11b-3c2c-4f77-a167-a69044f26021; _pxff_cc=U2FtZVNpdGU9TGF4Ow==; pxcts=2eabf1ef-98b7-11ed-9997-736e78725178; _pxvid=2dac7f64-98b7-11ed-8b25-4a746e794d6e; accept_cookies_and_privacy_and_terms=1; country_code=RU; _sp_ses.8cd1=*; sp=c20821d6-75ce-4b47-b530-63da36b7c54e; access_token_global=eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqQXpNbUpoTmprd09HVTFaalJsWW1Vek5HVXdaRGsyT0Rjek9UZGpNakZrWkRFM1kyTmxaR1U0TlRVeU5ESmlaV0kwTVdOaVpqRTVZV1E1TXpBMVpEa2kiLCJleHAiOm51bGwsInB1ciI6ImNvb2tpZS5hY2Nlc3NfdG9rZW5fZ2xvYmFsIn19--226f3ed84235e8651304e2381a56761ee2747fff; _pxff_tm=1; recipe_view_count_ru=2; _pxff_ne=1; _pxhd=ub3EfqpOR1lxD2xlO4nZNPOK6F72EWkRZQNZ/htvQ0pi9CELyGb2wdP5myfAz9Al1gHRpqZSXSW9zbxrZpNo6Q==:qDDdRC5HzNCfd4w77aJHIcf/Xqyo8FbOfgrULvhqcurFoFUgDHfHiMlD0QiQPHjQuuEo5fljulW-6p44Vci5Et0qXWVHe0uQa1VAh-2lPwQ=; _sp_id.8cd1=b198e874-307c-4893-9db0-4305efe7d401.1674214839.1.1674214862..377c4eeb-be88-4223-bc16-b688cbb423fb..6cbe436f-8aa5-4eb5-a8f9-d60f6c6effbd.1674214838763.7; _global_web_session=cVV0BzHeUln5wjTDe5xagfEVuFIAvTH1zM2jy2nM%2FcbzTkP2jt2XNLGtLxJqWr3h3oruNj9dDwQiUDRtwIO8%2FH6iIpg5fXCa6twOZmwEmmXWME9F4ReLME1J8r%2FDOe4YP9EY0hvKC885rvYjqDgPyx0x52LcUzkdt2%2BbAR8%2FO5ANg0dutXJU1R1V4vkDpVjlGhcHVjb74fTAuMiIwXM1DZFXVKwUNlrvAlqy8sveK1T5dqXxLqmrI4jaf%2B81x4woddKqjDeEUmUrHOX%2BWS8Q2Noh0zVIkO%2BaZ2QtoEGMROJdp1SVW3UIq0KT3HPq6lC4rahuioSF2wiVI%2Fxsg3dy--EE6iBSjcrcmX%2BRCE--jbD4CICRff9S%2FMBOX38z0A%3D%3D",
      "sec-ch-ua":
          ''''"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"''',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "Windows",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
    });
  }
}

enum Mode {
  edge, chrome, brave
}

void makePages() async {
  // 404 for 1368 and some before
  int endId = 9000;
  int startId = 1260;
  int current = startId;
  int collectionSize = 8;
  String prefix = "page";
  for (int i = 5; i <= 100; i++) {
    String name = '$prefix$i';
    bool created = await RecipesSender().makeCollection(name);
    if (!created) {
      print("Failed to make collection: $name");
      return;
    }
    for (int j = 0; j <= collectionSize; j++) {
      bool added = await RecipesSender().addToCollection(name, current);
      if (!added) {
        print("Failed to add to collection $current");
      }
      current++;
    }
    print('Made collection $name');
  }
  return;
}

Future<void> makeNewCollection() async {
  String name = "diamond";
  List<int> ids = [
    1374, 1394, 1414, 1463, 8840, 10082,
    10084, 10120, 10129, 10156, 10189,
    6491, 10218, 10299, 10351, 10355,
    10360, 1406, 11353, 11363, 1371,
  ];
  bool created = await RecipesSender().makeCollection(name);
  if (!created) {
    print('Failed to make collection $name');
    return;
  }
  for (int id in ids) {
    bool added = await RecipesSender().addToCollection(name, id);
    if (!added) {
      print('Failed to add $id to $name');
    }
  }
}

main(List<String> args) async {
  if (args.isEmpty) {
    print("USAGE: ./prog <mode>\nmode is one of: c, e, b\n(chrome, edge, brave)");
    return;
  }
  String arg = args.first;
  Mode mode = Mode.chrome;
  if (arg.startsWith('c')) {
    mode = Mode.chrome;
  } else if (arg.startsWith('e')) {
    mode = Mode.edge;
  } else if (arg.startsWith('b')) {
    mode = Mode.brave;
  } else {
    print("USAGE: ./prog <mode>\nmode is one of: c, e, b\n(chrome, edge, brave)");
    return;
  }
  // 16752402 16752475 16700311
  // int firstId = 16752402 + 4 + 20 + 100 + 100;
  // int firstId = 16700311 + 100 + 500 + 100 + 350 + 380 + 222 + 15 + 70 + 80
  //     + 500 + 14 + 15 + 12 + 14 + 463 + 34 + 11; // + 79
  // int firstId = 16600000;
  List<int> ids = []; // 275 is bad, now fixed the issue
  // server id -- 263, 273
  //              274 -
  // от 240 до 1260 таймеры сами не ставились 
  //https://cookpad.com/ru/recipes/16718292
  // LAST -- https://cookpad.com/ru/recipes/16718902
  String fileName = "current_chrome";
  if (mode == Mode.edge) {
    fileName = "current_edge";
  } else if (mode == Mode.brave) {
    fileName = "current_brave";
  }
  File file = File("C:/Users/ms_dr/AndroidStudioProjects/voice_recipe/lib/parser/$fileName");
  int firstId = int.parse(file.readAsStringSync());
  for (int i = 0; i < 10000; i++) {
    print("[PARSER] watch https://cookpad.com/ru/recipes/${firstId + i}");
    file.writeAsString("${firstId + i}");
    try {
      Recipe? recipe = await CookPadParser().getRecipe(firstId + i, mode);
      if (recipe != null) {
        int id = await RecipesSender().sendRecipe(recipe);
        if (id > 0) {
          ids.add(id);
          RecipesSender().addToCollection('saved', id);
          print("[PARSER] GOT RECIPE https://talkychef.ru/recipe/$id      ^_^");
        } else {
          print("[PARSER] SERVER DIDN'T ACCEPT");
        }
      }
    } catch (e) {
      print("[PARSER] $e");
    }
  }
  print("[PARSER] $ids");
}
