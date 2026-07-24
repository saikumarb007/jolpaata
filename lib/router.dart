import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/models/lullaby.dart';
import 'features/catalogue/catalogue_page.dart';
import 'features/favourites/favourites_page.dart';
import 'features/player/player_page.dart';
import 'features/settings/settings_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const HomeShell()),
    GoRoute(
      path: '/player',
      builder: (_, state) => PlayerPage(lullaby: state.extra as Lullaby),
    ),
  ],
);

/// Bottom-nav home over the three main tabs.
// ponytail: IndexedStack + BottomNavigationBar is less wiring than a
// StatefulShellRoute for three static tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = [
    CataloguePage(),
    FavouritesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.library_music), label: 'Catalogue'),
          NavigationDestination(
              icon: Icon(Icons.favorite), label: 'Favourites'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
