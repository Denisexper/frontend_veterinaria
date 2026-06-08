class Propietario {
  final String id;
  final String nombre;
  final String telefono;
  final String direccion;
  final String correo;

  Propietario({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.correo,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['_id'] ?? '',
      nombre: json['name'] ?? '',
      telefono: json['phone'] ?? '',
      direccion: json['address'] ?? '',
      correo: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nombre,
        'phone': telefono,
        'address': direccion,
        'email': correo,
      };
}
