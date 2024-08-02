import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://www.eventbriteapi.com/v3/";
  final String bearerToken = "ZNLVTVHDYLLLHOTYOBMZ";

  Future<Map<String, dynamic>> fetchEventData(String eventID) async {
    final response = await http.get(
      Uri.parse("$baseUrl/events/$eventID/?expand=venue"),
      headers: {
        "Authorization": "Bearer $bearerToken",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } 
    else {
      throw Exception("Failed to load event data");
    }
  }

  Future<Map<String, dynamic>> fetchEventID(String organisationID) async {
    final response = await http.get(
      Uri.parse("$baseUrl/organizations/$organisationID/events/"),
      headers: {
        "Authorization": "Bearer $bearerToken",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } 
    else {
      throw Exception("Failed to load event data");
    }
  }
}
