import 'propietario.dart';

class Perro {
  final String id;
  final String nombre;
  final String raza;
  final int edad;
  final Propietario? propietario;

  Perro({
    required this.id,
    required this.nombre,
    required this.raza,
    required this.edad,
    this.propietario,
  });

  factory Perro.fromJson(Map<String, dynamic> json) {
    return Perro(
      id: json['_id'] ?? '',
      nombre: json['name'] ?? '',
      raza: json['race'] ?? '',
      edad: (json['age'] ?? 0) is int
          ? json['age']
          : int.tryParse(json['age'].toString()) ?? 0,
      propietario: json['owner'] is Map<String, dynamic>
          ? Propietario.fromJson(json['owner'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nombre,
        'race': raza,
        'age': edad,
        'owner': propietario?.id,
      };
}
