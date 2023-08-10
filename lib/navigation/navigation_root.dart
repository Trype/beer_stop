import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationRoot extends StatelessWidget {
  const NavigationRoot({Key? key, required this.navigationShell}) : super(key: key);

  final StatefulNavigationShell navigationShell;

  static NavigationRoot? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<NavigationRoot>();

  get nShell => navigationShell;


  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Search', icon: Icon(Icons.search)),
          NavigationDestination(label: 'Search', icon: Icon(Icons.favorite)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
