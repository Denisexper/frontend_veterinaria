import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/historial.dart';
import '../models/perro.dart';
import '../models/propietario.dart';

class ApiService {
  // ── Perros ───────────────────────────────────────────────────────────────

  static Future<List<Perro>> getPerros() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/perros'));
    _verificarRespuesta(response, 'cargar perros');
    final List data = _extraerLista(response.body);
    return data.map((e) => Perro.fromJson(e)).toList();
  }

  static Future<void> createPerro(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/perros'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    _verificarRespuesta(response, 'crear perro');
  }

  // ── Propietarios ─────────────────────────────────────────────────────────

  static Future<List<Propietario>> getPropietarios() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/propietarios'));
    _verificarRespuesta(response, 'cargar propietarios');
    final List data = _extraerLista(response.body);
    return data.map((e) => Propietario.fromJson(e)).toList();
  }

  static Future<void> createPropietario(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/propietarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    _verificarRespuesta(response, 'crear propietario');
  }

  // ── Historial ─────────────────────────────────────────────────────────────

  static Future<List<Historial>> getHistorial(String perroId) async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/historial/$perroId'));
    _verificarRespuesta(response, 'cargar historial');
    final List data = _extraerLista(response.body);
    return data.map((e) => Historial.fromJson(e)).toList();
  }

  static Future<void> createHistorial(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/historial'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    _verificarRespuesta(response, 'crear historial');
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  static void _verificarRespuesta(http.Response response, String accion) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al $accion (${response.statusCode})');
    }
  }

  // Soporta respuesta como array directo o como { "data": [...] }
  static List _extraerLista(String body) {
    final decoded = json.decode(body);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['data'] is List) return decoded['data'];
    return [];
  }
}
