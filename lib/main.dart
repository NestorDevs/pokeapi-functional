import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokeapi_functional/controllers/pokemon_provider.dart';

//import 'controllers/pokemon_state.dart';

void main() {
  /// [ProviderScope] required for riverpod state management
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [TextEditingController] using hooks
    final controller = useTextEditingController();
    final requestStatus = ref.watch(pokemonStateProvider);
    final pokemonNotifier = ref.watch(pokemonStateProvider.notifier);

    return MaterialApp(
      title: 'Fpdart PokeAPI',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// [TextField] and [ElevatedButton] to input pokemon id to fetch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Insert pokemon id number',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pokemonNotifier.fetch(controller.text),
              child: const Text('Get my pokemon!'),
            ),
            const SizedBox(height: 20),

            /// Map each [AsyncValue] to a different UI
            requestStatus.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              /// When either is [Left], display error message 💥
              error: (error, stackTrace) => Text(error.toString()),

              /// When either is [Right], display pokemon 🤩
              data: (pokemon) => Card(
                child: Column(
                  children: [
                    Image.network(
                      pokemon.sprites.frontDefault,
                      width: 200,
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                      ),
                      child: Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
