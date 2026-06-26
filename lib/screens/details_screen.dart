import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.dart';

class DetailsScreen extends StatelessWidget {
  final Pokemon pokemon;
  const DetailsScreen({super.key, required this.pokemon});

  // Função para salvar no Firebase
  Future<void> _favoritar(BuildContext context) async {
    await FirebaseFirestore.instance.collection('favoritos').add({
      'nome': pokemon.name,
      'id': pokemon.id,
      'data': DateTime.now(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${pokemon.name} salvo nos favoritos!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name.toUpperCase())),
      body: Center(
        child: Column(
          children: [
            Image.network(pokemon.imageUrl, height: 250),
            Text("ID: ${pokemon.id}", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _favoritar(context),
              child: const Text("Adicionar aos Favoritos"),
            ),
          ],
        ),
      ),
    );
  }
}
