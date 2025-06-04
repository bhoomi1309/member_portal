import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  List<Map<String, dynamic>> userList = [];

  String apiURL = "https://dummyjson.com/users";

  Future<List<Map<String, dynamic>>> getUserList({required int page, required int limit}) async {
    final response = await http.get(Uri.parse('$apiURL?limit=$limit&skip=${page * limit}'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decoded['users']);
    } else {
      throw Exception('Error fetching users');
    }
  }

  Future<void> addUser({required Map<String, dynamic> newUser}) async {
    try {
      final response = await http.post(Uri.parse(apiURL),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(newUser));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Added');
      }
    } catch (e) {
      print('Error');
    }
  }

  Future<void> updateUser({required Map<String, dynamic> newUser, required int index}) async {
    final response = await http.put(
        Uri.parse('$apiURL/$index'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newUser)
    );
    if(response.statusCode==200 || response.statusCode==201){
      print('Updated');
    }
    else{
      throw Exception('Error');
    }
  }

  Future<void> deleteUser({required int index}) async {
    final response = await http.delete(Uri.parse('$apiURL/$index'),);

    if(response.statusCode == 200 ){
      print('Deleted');
    }
    else{
      throw Exception('Error');
    }
  }
}
