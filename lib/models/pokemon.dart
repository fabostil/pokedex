// lib/models/pokemon.dart

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  // Este método converte o JSON que vem da API para um objeto que o Flutter entende
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
    );
  }
}
