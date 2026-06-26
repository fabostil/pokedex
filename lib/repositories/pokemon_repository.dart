import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonRepository {
  Future<List<Pokemon>> fetchPokemons() async {
    // Busca uma lista de 20 Pokémons da API
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      // Como a lista inicial só tem nome e URL, buscamos os detalhes de cada um
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final detailResponse = await http.get(Uri.parse(result['url']));
        if (detailResponse.statusCode == 200) {
          pokemons.add(Pokemon.fromJson(json.decode(detailResponse.body)));
        }
      }
      return pokemons;
    } else {
      throw Exception('Falha ao carregar Pokémons');
    }
  }
}
