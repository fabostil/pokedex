import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importante para o Firebase
import 'firebase_options.dart'; // Gerado pelo comando flutterfire configure
import 'screens/home_screen.dart'; // Importando a tela que criamos

void main() async {
  // Garante que os bindings do Flutter estão inicializados antes de rodar o Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções geradas para a sua plataforma
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de "debug" do canto
      title: 'Pokédex App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Define a sua HomeScreen como tela inicial
    );
  }
}
