class Historial {
  final String id;
  final String perroId;
  final double peso;
  final String diagnostico;
  final String tratamiento;
  final String observaciones;
  final DateTime? fecha;

  Historial({
    required this.id,
    required this.perroId,
    required this.peso,
    required this.diagnostico,
    required this.tratamiento,
    required this.observaciones,
    this.fecha,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    final dogField = json['dog'];
    final perroId =
        dogField is Map ? dogField['_id'] ?? '' : dogField?.toString() ?? '';

    DateTime? fecha;
    if (json['createdAt'] != null) {
      fecha = DateTime.tryParse(json['createdAt']);
    } else if (json['fecha'] != null) {
      fecha = DateTime.tryParse(json['fecha']);
    }

    return Historial(
      id: json['_id'] ?? '',
      perroId: perroId,
      peso: (json['weight'] ?? 0).toDouble(),
      diagnostico: json['diagnosis'] ?? '',
      tratamiento: json['treatment'] ?? '',
      observaciones: json['observations'] ?? '',
      fecha: fecha,
    );
  }

  Map<String, dynamic> toJson() => {
        'dog': perroId,
        'weight': peso,
        'diagnosis': diagnostico,
        'treatment': tratamiento,
        'observations': observaciones,
      };
}
