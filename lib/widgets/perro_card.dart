import 'package:flutter/material.dart';

import '../models/perro.dart';
import '../screens/detalle_perro_screen.dart';

class PerroCard extends StatelessWidget {
  final Perro perro;

  const PerroCard({super.key, required this.perro});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: const Icon(Icons.pets, color: Colors.teal),
        ),
        title: Text(
          perro.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Raza: ${perro.raza}'),
        trailing: const Icon(Icons.chevron_right, color: Colors.teal),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetallePerroScreen(perro: perro),
          ),
        ),
      ),
    );
  }
}
