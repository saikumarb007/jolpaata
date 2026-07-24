import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/ads/ad_banner.dart';
import '../../core/models/lullaby.dart';
import '../../core/repositories/catalogue_repository.dart';
import '../favourites/favourites_cubit.dart';

/// Browse all lullabies from the bundled catalogue. A banner ad sits at the
/// bottom of the browse list — never on the player, so a running lullaby is
/// never interrupted by an ad.
class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jolpaata')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Lullaby>>(
              future: context.read<CatalogueRepository>().load(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return LullabyList(items: snap.data!);
              },
            ),
          ),
          const SafeArea(child: AdBanner()),
        ],
      ),
    );
  }
}

/// Shared list widget — reused by the favourites screen.
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
      itemBuilder: (context, i) {
        final l = items[i];
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(l.titleTelugu.isNotEmpty ? l.titleTelugu : l.title),
          subtitle: Text(l.artist),
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
      },
    );
  }
}
