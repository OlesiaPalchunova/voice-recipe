import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/screens/authorization/auth_screen.dart';
import 'package:voice_recipe/screens/authorization/forgot_password_screen.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/screens/authorization/register_screen.dart';
import 'package:voice_recipe/screens/create_recipe_screen.dart';
import 'package:voice_recipe/screens/future_collection_screen.dart';
import 'package:voice_recipe/screens/future_recipe_screen.dart';
import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/screens/collections_list_screen.dart';
import 'package:voice_recipe/screens/not_found_screen.dart';

import 'config.dart';

class VoiceRecipeApp extends StatefulWidget {
  const VoiceRecipeApp({super.key});

  @override
  State<VoiceRecipeApp> createState() => _VoiceRecipeAppState();
}

class _VoiceRecipeAppState extends State<VoiceRecipeApp> {
  final routes = RouteMap(
      onUnknownRoute: (route) {
        return const MaterialPage(child: NotFoundScreen());
      },
      routes: {
        // Home.route: (_) => const CupertinoTabPage(
        //       child: Home(),
        //       paths: [
        //         CreateRecipeScreen.route,
        //         AuthScreen.route,
        //         CollectionsListScreen.route,
        //         LoginScreen.route,
        //         RegisterScreen.route,
        //         ForgotPasswordScreen.route,
        //       ],
        //     ),
        Home.route: (_) => const MaterialPage(child: Home()),
        CreateRecipeScreen.route: (_) =>
            const MaterialPage(child: CreateRecipeScreen()),
        AuthScreen.route: (_) => const MaterialPage(child: AuthScreen()),
        CollectionsListScreen.route: (_) =>
            const MaterialPage(child: CollectionsListScreen()),
        LoginScreen.route: (_) => const MaterialPage(child: LoginScreen()),
        RegisterScreen.route: (_) =>
            const MaterialPage(child: RegisterScreen()),
        ForgotPasswordScreen.route: (_) =>
            const MaterialPage(child: ForgotPasswordScreen()),
        '${FutureRecipeScreen.route}:id': (info) {
          int id = int.parse(info.pathParameters['id']!);
          return MaterialPage(child: FutureRecipeScreen(recipeId: id));
        },
        '${FutureCollectionScreen.route}:name': (info) {
          String name = info.pathParameters['name']!;
          return MaterialPage(child: FutureCollectionScreen(name: name));
        }
      });

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
