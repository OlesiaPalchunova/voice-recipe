import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/pages/account/auth_page.dart';
import 'package:voice_recipe/pages/account/forgot_password_page.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/account/register_page.dart';
import 'package:voice_recipe/pages/constructor/create_recipe_page.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';
import 'package:voice_recipe/pages/recipe/future_recipe_page.dart';
import 'package:voice_recipe/pages/home_page.dart';
import 'package:voice_recipe/pages/collections/collections_list_page.dart';
import 'package:voice_recipe/pages/not_found_page.dart';

import 'config/config.dart';

class VoiceRecipeApp extends StatefulWidget {
  const VoiceRecipeApp({super.key});

  @override
  State<VoiceRecipeApp> createState() => _VoiceRecipeAppState();
}

class _VoiceRecipeAppState extends State<VoiceRecipeApp> {
  final routes = RouteMap(
      onUnknownRoute: (route) {
        return const MaterialPage(child: NotFoundPage());
      },
      routes: {
        HomePage.route: (_) => const MaterialPage(child: HomePage()),
        CreateRecipePage.route: (_) =>
            const MaterialPage(child: CreateRecipePage()),
        AuthPage.route: (_) => const MaterialPage(child: AuthPage()),
        CollectionsListPage.route: (_) =>
            const MaterialPage(child: CollectionsListPage()),
        LoginPage.route: (_) => const MaterialPage(child: LoginPage()),
        RegisterPage.route: (_) =>
            const MaterialPage(child: RegisterPage()),
        ForgotPasswordPage.route: (_) =>
            const MaterialPage(child: ForgotPasswordPage()),
        '${FutureCollectionPage.route}:name': (info) {
          String name = info.pathParameters['name']!;
          return MaterialPage(child: FutureCollectionPage(name: name));
        },
        '${FutureRecipePage.route}:id': materialRecipeRoute,
        '${FutureCollectionPage.route}:name/:id': materialRecipeRoute,
        '/created/:id': materialRecipeRoute,
        '/favorites/:id': materialRecipeRoute,
      });

  static MaterialPage<dynamic> materialRecipeRoute(RouteData info) {
    int id = int.parse(info.pathParameters['id']!);
    return MaterialPage(child: FutureRecipePage(recipeId: id));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: Config.lightTheme,
      title: Config.appName,
      routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
      routeInformationParser: const RoutemasterParser(),
      supportedLocales: const [
        Locale('ru', 'RU')
      ],
    );
  }
}
