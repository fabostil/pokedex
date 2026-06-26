import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonRepository _repository = PokemonRepository();
  late Future<List<Pokemon>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = _repository.fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokédex")),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final pokemons = snapshot.data!;
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(pokemons[index].imageUrl),
                title: Text(pokemons[index].name.toUpperCase()),
              );
            },
          );
        },
      ),
    );
  }
}
