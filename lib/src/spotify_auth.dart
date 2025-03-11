import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
const redirectUri = 'shoreapp://callback';

class SpotifyAuth {
  static Future<String?> authenticate() async {
    final url =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=token&redirect_uri=$redirectUri&scope=user-read-private%20user-read-email%20playlist-read-private';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: "shoreapp",
    );

    final token =
        Uri.parse(result).fragment
            .split("&")
            .firstWhere((e) => e.startsWith("access_token"))
            .split("=")[1];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spotify_token', token);

    return token;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spotify_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('spotify_token');
  }

  Future<List<dynamic>> fetchPlaylists(String token) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/playlists'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load playlists');
    }
  }
}
