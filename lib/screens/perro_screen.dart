import 'package:flutter/material.dart';

import '../models/propietario.dart';
import '../services/api_service.dart';

class PerroScreen extends StatefulWidget {
  const PerroScreen({super.key});

  @override
  State<PerroScreen> createState() => _PerroScreenState();
}

class _PerroScreenState extends State<PerroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _razaCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();

  List<Propietario> _propietarios = [];
  Propietario? _propietarioSeleccionado;
  bool _cargandoPropietarios = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarPropietarios();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _razaCtrl.dispose();
    _edadCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarPropietarios() async {
    try {
      final lista = await ApiService.getPropietarios();
      setState(() {
        _propietarios = lista;
        _cargandoPropietarios = false;
      });
    } catch (e) {
      setState(() => _cargandoPropietarios = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar propietarios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await ApiService.createPerro({
        'name': _nombreCtrl.text.trim(),
        'race': _razaCtrl.text.trim(),
        'age': int.parse(_edadCtrl.text.trim()),
        'owner': _propietarioSeleccionado!.id,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perro registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Perro'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo(_nombreCtrl, 'Nombre del perro', Icons.pets),
              const SizedBox(height: 14),
              _campo(_razaCtrl, 'Raza', Icons.category),
              const SizedBox(height: 14),
              _campo(_edadCtrl, 'Edad (años)', Icons.cake,
                  tipo: TextInputType.number),
              const SizedBox(height: 14),
              _buildDropdown(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    if (_cargandoPropietarios) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return DropdownButtonFormField<Propietario>(
      value: _propietarioSeleccionado,
      decoration: const InputDecoration(
        labelText: 'Propietario',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      items: _propietarios
          .map((p) => DropdownMenuItem(value: p, child: Text(p.nombre)))
          .toList(),
      onChanged: (v) => setState(() => _propietarioSeleccionado = v),
      validator: (v) => v == null ? 'Seleccione un propietario' : null,
    );
  }

  Widget _campo(
    TextEditingController ctrl,
    String etiqueta,
    IconData icono, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        border: const OutlineInputBorder(),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Este campo es requerido' : null,
    );
  }
}
