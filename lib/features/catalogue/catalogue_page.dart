import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/ads/ad_banner.dart';
import '../../core/models/category.dart';
import '../../core/models/lullaby.dart';
import '../../core/repositories/catalogue_repository.dart';
import '../favourites/favourites_cubit.dart';

/// Browse all lullabies, grouped by category. A banner ad sits at the bottom of
/// the browse list — never on the player, so a running lullaby is never
/// interrupted by an ad.
class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<CatalogueRepository>();
    return Scaffold(
      appBar: AppBar(title: const Text('Jolpaata')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<(List<Category>, List<Lullaby>)>(
              future: _load(repo),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final (categories, lullabies) = snap.data!;
                return _CategorisedList(
                    categories: categories, lullabies: lullabies);
              },
            ),
          ),
          const SafeArea(child: AdBanner()),
        ],
      ),
    );
  }

  Future<(List<Category>, List<Lullaby>)> _load(CatalogueRepository r) async {
    final results = await Future.wait([r.categories(), r.load()]);
    return (results[0] as List<Category>, results[1] as List<Lullaby>);
  }
}

/// One colored header per category, followed by that category's lullabies.
/// Categories with no lullabies are skipped.
class _CategorisedList extends StatelessWidget {
  const _CategorisedList({required this.categories, required this.lullabies});

  final List<Category> categories;
  final List<Lullaby> lullabies;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final c in categories)
          ...() {
            final items =
                lullabies.where((l) => l.categoryId == c.id).toList();
            if (items.isEmpty) return const <Widget>[];
            return [
              _CategoryHeader(category: c, count: items.length),
              ...items.map((l) => LullabyTile(lullaby: l)),
            ];
          }(),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category, required this.count});

  final Category category;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: category.color.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(width: 4, height: 32, color: category.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.labelTelugu,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(category.label,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text('$count'),
        ],
      ),
    );
  }
}

/// A single lullaby row with a favourite toggle. Shared by catalogue and
/// favourites screens.
class LullabyTile extends StatelessWidget {
  const LullabyTile({super.key, required this.lullaby});

  final Lullaby lullaby;

  @override
  Widget build(BuildContext context) {
    final l = lullaby;
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(l.titleTelugu.isNotEmpty ? l.titleTelugu : l.title),
      subtitle: Text(l.composer),
      trailing: BlocBuilder<FavouritesCubit, Set<String>>(
        builder: (context, favs) => IconButton(
          icon: Icon(
            favs.contains(l.id) ? Icons.favorite : Icons.favorite_border,
          ),
          onPressed: () => context.read<FavouritesCubit>().toggle(l.id),
        ),
      ),
      onTap: () => context.push('/player', extra: l),
    );
  }
}

/// Flat list — used by the favourites screen.
class LullabyList extends StatelessWidget {
  const LullabyList({super.key, required this.items});

  final List<Lullaby> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No lullabies yet'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => LullabyTile(lullaby: items[i]),
    );
  }
}
