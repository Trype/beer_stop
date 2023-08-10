// private navigators
import 'package:beer_stop/data/Alcohol.dart';
import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/navigation/navigation_root.dart';
import 'package:beer_stop/screens/alcohol_description_screen.dart';
import 'package:beer_stop/screens/home_screen.dart';
import 'package:beer_stop/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');

// the one and only GoRouter instance
final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return NavigationRoot(
            navigationShell: navigationShell);
      },
      branches: [
        // first branch (A)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: HomeScreen.route,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: AlcoholDescriptionScreen.route,
                  builder: (context, state)
                  {
                    Alcohol alcohol = state.extra as Alcohol;
                    return AlcoholDescriptionScreen(alcohol: alcohol,
                        maxHeight: double.parse(state.pathParameters['maxWidth']!),
                        maxWidth: double.parse(state.pathParameters['maxHeight']!));
                  }
                ),
              ],
            ),
          ],
        ),
        // second branch (B)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: SearchScreen.route,
                pageBuilder: (context, state) {
                AlcoholFilters filters = (state.extra ?? AlcoholFilters()) as AlcoholFilters ;
                return NoTransitionPage(
                  child: SearchScreen(filters: filters),
                );
                },
              routes: [
                // child route
                GoRoute(
                  path: AlcoholDescriptionScreen.route,
                  builder: (context, state) {
                    Alcohol alcohol = state.extra as Alcohol;
                    return AlcoholDescriptionScreen(alcohol: alcohol,
                        maxHeight: double.parse(state.pathParameters['maxWidth']!),
                        maxWidth: double.parse(state.pathParameters['maxHeight']!));
                  }
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
