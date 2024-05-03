import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/fetch_pokemon.dart';
import '../models/pokemon.dart';

part 'pokemon_provider.g.dart';

@riverpod
class PokemonState extends _$PokemonState {
  @override
  FutureOr<Pokemon> build() async =>
      fetchRandomPokemon.getOrElse((l) => throw Exception(l)).run();

  Future<Unit> fetch(String pokemonId) async =>
      _pokemonRequest(() => fetchPokemonFromUserInput(pokemonId));

  Future<Unit> _pokemonRequest(
    TaskEither<String, Pokemon> Function() request,
  ) async {
    state = const AsyncLoading();
    final pokemon = request();
    state = (await pokemon.run()).match(
      (error) => AsyncError(error, StackTrace.current),
      (pokemon) => AsyncData(pokemon),
    );
    return unit;
  }
}
