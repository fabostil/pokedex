import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.dart';

class DetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  const DetailsScreen({super.key, required this.pokemon});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isProcessing = false;

  // Função que adiciona ou remove dependendo do estado atual
  Future<void> _toggleFavorito(bool jaE_Favorito) async {
    setState(() => _isProcessing = true);

    final docRef = FirebaseFirestore.instance
        .collection('favoritos')
        .doc(widget.pokemon.id.toString());

    try {
      if (jaE_Favorito) {
        // Se já era favorito, deleta do banco
        await docRef.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${widget.pokemon.name.toUpperCase()} removido dos favoritos! 💔",
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Se não era, adiciona usando o ID do pokemon como nome do documento
        await docRef.set({
          'nome': widget.pokemon.name,
          'id': widget.pokemon.id,
          'imageUrl': widget.pokemon.imageUrl,
          'data': DateTime.now(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${widget.pokemon.name.toUpperCase()} adicionado aos favoritos! ❤️",
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao acessar o banco de dados."),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        widget.pokemon.imageUrl,
                        height: 200,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "#${widget.pokemon.id.toString().padLeft(3, '0')}",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pokemon.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Usamos um StreamBuilder para monitorar em tempo real se esse Pokémon específico está no banco
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('favoritos')
                          .doc(widget.pokemon.id.toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Enquanto checa o banco, mostra o botão desabilitado carregando
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ElevatedButton(
                            onPressed: null,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        // Se o documento existe, significa que o Pokémon JÁ É favorito
                        bool jaE_Favorito =
                            snapshot.hasData && snapshot.data!.exists;

                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(220, 50),
                            backgroundColor: jaE_Favorito
                                ? Colors.red[50]
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isProcessing
                              ? null
                              : () => _toggleFavorito(jaE_Favorito),
                          icon: _isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  jaE_Favorito
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                          label: Text(
                            _isProcessing
                                ? "Processando..."
                                : (jaE_Favorito ? "Desfavoritar" : "Favoritar"),
                            style: TextStyle(
                              color: jaE_Favorito ? Colors.red[900] : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
