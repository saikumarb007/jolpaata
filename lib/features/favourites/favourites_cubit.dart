import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/repositories/favourites_repository.dart';

/// Shared favourite-ids state, backed by the local Hive box. The one piece of
/// mutable state multiple screens read, so it earns a Cubit.
class FavouritesCubit extends Cubit<Set<String>> {
  FavouritesCubit(this._repo) : super(_repo.all());

  final FavouritesRepository _repo;

  Future<void> toggle(String id) async {
    await _repo.toggle(id);
    emit(_repo.all());
  }

  bool isFavourite(String id) => state.contains(id);
}
