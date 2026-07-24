import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/repositories/catalogue_repository.dart';
import 'core/repositories/favourites_repository.dart';
import 'features/favourites/favourites_cubit.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage — the offline source of truth.
  await Hive.initFlutter();
  await FavouritesRepository.init();

  // Ads (the only network dependency). Fire-and-forget: if it can't reach
  // Google the app still runs fully offline.
  unawaited(MobileAds.instance.initialize());

  runApp(const JolpaataApp());
}

class JolpaataApp extends StatelessWidget {
  const JolpaataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => CatalogueRepository()),
        RepositoryProvider(create: (_) => FavouritesRepository()),
      ],
      child: BlocProvider(
        create: (context) =>
            FavouritesCubit(context.read<FavouritesRepository>()),
        child: MaterialApp.router(
          title: 'Jolpaata',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
