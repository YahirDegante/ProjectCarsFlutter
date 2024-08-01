class CarModel {
  final String id;
  final String marca;
  final String cilindrada;
  final String color;
  final String modelo;

  CarModel({
    required this.id,
    required this.marca,
    required this.cilindrada,
    required this.color,
    required this.modelo,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      marca: json['marca'],
      cilindrada: json['cilindrada'],
      color: json['color'],
      modelo: json['modelo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'cilindrada': cilindrada,
      'color': color,
      'modelo': modelo,
    };
  }
}
