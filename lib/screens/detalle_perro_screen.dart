import 'package:flutter/material.dart';

import '../models/historial.dart';
import '../models/perro.dart';
import '../models/propietario.dart';
import '../services/api_service.dart';
import '../widgets/historial_card.dart';

class DetallePerroScreen extends StatefulWidget {
  final Perro perro;

  const DetallePerroScreen({super.key, required this.perro});

  @override
  State<DetallePerroScreen> createState() => _DetallePerroScreenState();
}

class _DetallePerroScreenState extends State<DetallePerroScreen> {
  List<Historial> _historial = [];
  bool _cargandoHistorial = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() => _cargandoHistorial = true);
    try {
      final data = await ApiService.getHistorial(widget.perro.id);
      setState(() {
        _historial = data;
        _cargandoHistorial = false;
      });
    } catch (e) {
      setState(() => _cargandoHistorial = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar historial: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _mostrarFormularioConsulta() async {
    final pesoCtrl = TextEditingController();
    final diagnosticoCtrl = TextEditingController();
    final tratamientoCtrl = TextEditingController();
    final observacionesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // El dialog retorna true si se guardó exitosamente, null/false si se canceló
    final guardado = await showDialog<bool>(
      context: context,
      builder: (ctx) => _DialogConsulta(
        formKey: formKey,
        pesoCtrl: pesoCtrl,
        diagnosticoCtrl: diagnosticoCtrl,
        tratamientoCtrl: tratamientoCtrl,
        observacionesCtrl: observacionesCtrl,
        perroId: widget.perro.id,
        ownerId: widget.perro.propietario?.id ?? '',
      ),
    );

    pesoCtrl.dispose();
    diagnosticoCtrl.dispose();
    tratamientoCtrl.dispose();
    observacionesCtrl.dispose();

    if (!mounted) return;

    if (guardado == true) {
      _cargarHistorial();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta registrada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perro.nombre),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFichaPaciente(),
            _buildFichaPropietario(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Historial Clínico',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildHistorial(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormularioConsulta,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Consulta'),
      ),
    );
  }

  Widget _buildFichaPaciente() {
    final perro = widget.perro;
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.teal.shade100,
                  child: const Icon(Icons.pets, color: Colors.teal, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      perro.nombre,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(perro.raza,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            _fila(Icons.cake, 'Edad', '${perro.edad} años'),
          ],
        ),
      ),
    );
  }

  Widget _buildFichaPropietario() {
    final Propietario? prop = widget.perro.propietario;
    if (prop == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('Sin datos de propietario.',
            style: TextStyle(color: Colors.grey)),
      );
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos del Propietario',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _fila(Icons.person, 'Nombre', prop.nombre),
            _fila(Icons.phone, 'Teléfono', prop.telefono),
            _fila(Icons.location_on, 'Dirección', prop.direccion),
            _fila(Icons.email, 'Correo', prop.correo),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorial() {
    if (_cargandoHistorial) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_historial.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Sin consultas registradas.\nPresiona el botón para agregar una.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _historial.length,
      itemBuilder: (_, i) => HistorialCard(historial: _historial[i]),
    );
  }

  Widget _fila(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 18, color: Colors.teal),
          const SizedBox(width: 8),
          Text('$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

}

// Dialog extraído como StatefulWidget para manejar su propio estado
// y evitar usar el context del padre dentro de callbacks asíncronos
class _DialogConsulta extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController pesoCtrl;
  final TextEditingController diagnosticoCtrl;
  final TextEditingController tratamientoCtrl;
  final TextEditingController observacionesCtrl;
  final String perroId;
  final String ownerId;

  const _DialogConsulta({
    required this.formKey,
    required this.pesoCtrl,
    required this.diagnosticoCtrl,
    required this.tratamientoCtrl,
    required this.observacionesCtrl,
    required this.perroId,
    required this.ownerId,
  });

  @override
  State<_DialogConsulta> createState() => _DialogConsultaState();
}

class _DialogConsultaState extends State<_DialogConsulta> {
  bool _guardando = false;

  Future<void> _guardar() async {
    if (!widget.formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await ApiService.createHistorial({
        'dog': widget.perroId,
        'owner': widget.ownerId,
        'weight': double.parse(widget.pesoCtrl.text.trim()),
        'diagnosis': widget.diagnosticoCtrl.text.trim(),
        'treatment': widget.tratamientoCtrl.text.trim(),
        'observations': widget.observacionesCtrl.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.medical_services, color: Colors.teal),
          SizedBox(width: 8),
          Text('Nueva Consulta Médica'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campo(widget.pesoCtrl, 'Peso (kg)', TextInputType.number),
              const SizedBox(height: 10),
              _campo(widget.diagnosticoCtrl, 'Diagnóstico', TextInputType.text),
              const SizedBox(height: 10),
              _campo(widget.tratamientoCtrl, 'Tratamiento', TextInputType.text),
              const SizedBox(height: 10),
              _campo(widget.observacionesCtrl, 'Observaciones', TextInputType.text),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _campo(TextEditingController ctrl, String etiqueta, TextInputType tipo) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
    );
  }
}
