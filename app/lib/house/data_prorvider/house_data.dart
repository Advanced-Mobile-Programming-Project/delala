import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:labjobfeature/house/models/house.dart';

class HouseDataProvider {
  final _baseUrl = 'http://192.168.137.1:3000';
  final http.Client httpClient;

  HouseDataProvider({@required this.httpClient}) : assert(httpClient != null);

  Future<House> createHouse(House house) async {
    final response = await httpClient.post(
      Uri.http('192.168.137.1:3000', '/api/house'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': house.title,
        'description': house.description,
        'bedrooms': house.bedrooms,
        'bathrooms': house.bathrooms,
        'cost': house.cost,
        'street': house.street,
        'city': house.city,
        'location': house.location,
        'category': house.category,
        'status': house.status,
      }),
    );
    print(House.fromJson(jsonDecode(response.body)));
    if (response.statusCode == 201) {
      return House.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create House.');
    }
  }

  Future<List<House>> getHouses() async {
    final response = await httpClient.get('$_baseUrl/api/house');
    if (response.statusCode == 200) {
      final houses = jsonDecode(response.body) as List;
      return houses.map((house) => House.fromJson(house)).toList();
    } else {
      throw Exception('Failed to load houses');
    }
  }

  Future<void> deleteHouse(String id) async {
    final response = await httpClient.delete(
      '$_baseUrl/api/job/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete house.');
    }
  }

  Future<void> updateHouse(House house) async {
    var id = house.id;
    print(id);
    final response = await httpClient.put('$_baseUrl/api/house/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': house.title,
          'description': house.description,
          'bedrooms': house.bedrooms,
          'bathrooms': house.bathrooms,
          'cost': house.cost,
          'street': house.street,
          'city': house.city,
          'location': house.location,
          'category': house.category,
          'status': house.status,
        }));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode != 204) {
      throw Exception('Failed to update house.');
    }
  }
}
