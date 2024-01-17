import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/pages/account/auth_page.dart';
import 'package:voice_recipe/pages/account/forgot_password_page.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/account/register_page.dart';
import 'package:voice_recipe/pages/profile_collection/catalogue_page.dart';
import 'package:voice_recipe/pages/account/user_page.dart';
import 'package:voice_recipe/pages/constructor/create_recipe_page.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';
import 'package:voice_recipe/pages/constructor/edit_recipe_page.dart';
import 'package:voice_recipe/pages/constructor/future_edit_page.dart';
import 'package:voice_recipe/pages/profile_collection/collection_page.dart';
import 'package:voice_recipe/pages/profile_collection/specific_collections_page.dart';
import 'package:voice_recipe/pages/recipe/future_recipe_page.dart';
import 'package:voice_recipe/pages/home_page.dart';
import 'package:voice_recipe/pages/collections/collections_list_page.dart';
import 'package:voice_recipe/pages/not_found_page.dart';
import 'package:voice_recipe/services/service_io.dart';


import 'config/config.dart';
import 'model/profile.dart';

class VoiceRecipeApp extends StatefulWidget {
  const VoiceRecipeApp({key});

  @override
  State<VoiceRecipeApp> createState() => _VoiceRecipeAppState();
}

class _VoiceRecipeAppState extends State<VoiceRecipeApp> {
  // Profile profile = Profile();
  @override
  void initState() {
    super.initState();
  }
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
        RegisterPage.route: (_) => const MaterialPage(child: RegisterPage()),
        // UserAccount.route: (_) => const MaterialPage(child: UserAccount(profile: profile,)),
        CataloguePage.route: (_) => const MaterialPage(child: CataloguePage(name: '', posts: [],)),
        ForgotPasswordPage.route: (_) =>
            const MaterialPage(child: ForgotPasswordPage()),
        '${FutureCollectionPage.route}:name': (info) {
          String name = info.pathParameters['name']!;
          return MaterialPage(child: FutureCollectionPage(name: name));
        },
        '/created': (_) => ServiceIO.loggedIn
            ? const MaterialPage(child: FutureCollectionPage(name: "created"))
            : const MaterialPage(child: NotFoundPage()),
        '/favorites': (_) => ServiceIO.loggedIn
            ? const MaterialPage(child: FutureCollectionPage(name: "favorites"))
            : const MaterialPage(child: NotFoundPage()),
        '/user': (_) => ServiceIO.loggedIn
            ? const MaterialPage(child: FutureCollectionPage(name: "user"))
            : const MaterialPage(child: NotFoundPage()),
        '/catalogue': (_) => ServiceIO.loggedIn
            ? const MaterialPage(child: FutureCollectionPage(name: "catalogue"))
            : const MaterialPage(child: NotFoundPage()),
        '/profile/collection_page${SpecificCollectionPage.route}:collectionId': (info) {
          return MaterialPage(
            child: SpecificCollectionPage(
              collectionId: int.parse(info.pathParameters['collectionId']!),
            ),
          );
        },
        '/profile${SpecificCollectionPage.route}:collectionId': (info) {
          return MaterialPage(
            child: SpecificCollectionPage(
              collectionId: int.parse(info.pathParameters['collectionId']!),
              showCategories: true,
              showLikes: false,
            ),
          );
        },
        '${SpecificCollectionPage.route}:collectionId': (info) {
          return MaterialPage(
            child: SpecificCollectionPage(
              collectionId: int.parse(info.pathParameters['collectionId']!),
            ),
          );
        },
        '/profile${CollectionPage.route}': (_) => MaterialPage(child: CollectionPage()),
        '${FutureRecipePage.route}:id': materialRecipeRoute,
        '${EditRecipePage.route}:id': (info) {
          int id = int.parse(info.pathParameters['id']!);
          return MaterialPage(child: FutureEditRecipePage(recipeId: id));
        },
        '${FutureCollectionPage.route}:name/:id': materialRecipeRoute,
        '/created/:id': materialRecipeRouteForLoggedIn,
        '/favorites/:id': materialRecipeRouteForLoggedIn,
      });

  static MaterialPage<dynamic> materialRecipeRoute(RouteData info) {
    print(9999);
    int id = int.parse(info.pathParameters['id']!);
    return MaterialPage(child: FutureRecipePage(recipeId: id));
  }

  static MaterialPage<dynamic> materialRecipeRouteForLoggedIn(RouteData info) {
    if (!ServiceIO.loggedIn) return const MaterialPage(child: NotFoundPage());
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
    );
  }
}
