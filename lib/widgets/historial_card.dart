import 'package:flutter/material.dart';

import '../models/historial.dart';

class HistorialCard extends StatelessWidget {
  final Historial historial;

  const HistorialCard({super.key, required this.historial});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fila(Icons.monitor_weight, 'Peso', '${historial.peso} kg'),
            _fila(Icons.medical_services, 'Diagnóstico', historial.diagnostico),
            _fila(Icons.medication, 'Tratamiento', historial.tratamiento),
            _fila(Icons.notes, 'Observaciones', historial.observaciones),
            if (historial.fecha != null)
              _fila(
                Icons.calendar_today,
                'Fecha',
                '${historial.fecha!.day}/${historial.fecha!.month}/${historial.fecha!.year}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icon, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.teal),
          const SizedBox(width: 8),
          Text('$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}
