import 'package:flutter/material.dart';

import '../models/perro.dart';
import '../services/api_service.dart';
import '../widgets/perro_card.dart';
import 'perro_screen.dart';
import 'propietario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Perro>> _perrosFuture;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    setState(() {
      _perrosFuture = ApiService.getPerros();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clínica Veterinaria'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargar,
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: FutureBuilder<List<Perro>>(
        future: _perrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _cargar, child: const Text('Reintentar')),
                ],
              ),
            );
          }
          final perros = snapshot.data ?? [];
          if (perros.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No hay pacientes registrados.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: perros.length,
            itemBuilder: (_, i) => PerroCard(perro: perros[i]),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.local_hospital, color: Colors.white, size: 44),
                SizedBox(height: 8),
                Text(
                  'Clínica Veterinaria',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.teal),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_add, color: Colors.teal),
            title: const Text('Registrar Propietario'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PropietarioScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets, color: Colors.teal),
            title: const Text('Registrar Perro'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerroScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
