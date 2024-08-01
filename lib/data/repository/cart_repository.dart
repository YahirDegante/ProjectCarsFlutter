import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String apiUrl;

  CarRepository({required this.apiUrl});

  Future<void> createCar(CarModel car) async {
    final response = await http.post(
      Uri.parse('$apiUrl/cars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()..remove('id')),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create car');
    }
  }

  Future<CarModel> getCar(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/cars/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return CarModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load car');
    }
  }

  Future<void> updateCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('$apiUrl/cars/${car.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/deleteCar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Car deleted successfully');
      } else {
        print('Failed to delete car: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<CarModel>> getAllCars() async {
    final response = await http.get(
      Uri.parse('$apiUrl/getCars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<CarModel>.from(l.map((model) => CarModel.fromJson(model)));
    } else {
      throw Exception('Failed to load cars');
    }
  }
}
