import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/lullaby.dart';
import '../../core/repositories/catalogue_repository.dart';
import '../catalogue/catalogue_page.dart' show LullabyList;
import 'favourites_cubit.dart';

/// Favourited lullabies — read from the local Hive-backed cubit, filtered
/// against the bundled catalogue.
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: FutureBuilder<List<Lullaby>>(
        future: context.read<CatalogueRepository>().load(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocBuilder<FavouritesCubit, Set<String>>(
            builder: (context, favs) {
              final items =
                  snap.data!.where((l) => favs.contains(l.id)).toList();
              return LullabyList(items: items);
            },
          );
        },
      ),
    );
  }
}
