import 'package:flutter/material.dart';

import '../services/api_service.dart';

class PropietarioScreen extends StatefulWidget {
  const PropietarioScreen({super.key});

  @override
  State<PropietarioScreen> createState() => _PropietarioScreenState();
}

class _PropietarioScreenState extends State<PropietarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    try {
      await ApiService.createPropietario({
        'name': _nombreCtrl.text.trim(),
        'phone': _telefonoCtrl.text.trim(),
        'address': _direccionCtrl.text.trim(),
        'email': _correoCtrl.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Propietario registrado exitosamente'),
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
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Propietario'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo(_nombreCtrl, 'Nombre completo', Icons.person),
              const SizedBox(height: 14),
              _campo(_telefonoCtrl, 'Teléfono', Icons.phone,
                  tipo: TextInputType.phone),
              const SizedBox(height: 14),
              _campo(_direccionCtrl, 'Dirección', Icons.location_on),
              const SizedBox(height: 14),
              _campo(_correoCtrl, 'Correo electrónico', Icons.email,
                  tipo: TextInputType.emailAddress),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _guardar,
                  icon: _cargando
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
