import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../src/spotify_auth.dart';

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({super.key});

  @override
  _SpotifyScreenState createState() => _SpotifyScreenState();
}

class _SpotifyScreenState extends State<SpotifyScreen> {
  String? token;
  List<dynamic> playlists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spotify Client')),
      body: token == null
          ? Center(
              child: ElevatedButton(
                onPressed: () async {
                  final newToken = await SpotifyAuth.authenticate();
                  if (newToken != null) {
                    setState(() => token = newToken);
                    _fetchPlaylists();
                  }
                },
                child: Text('Login with Spotify'),
              ),
            )
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  title: Text(playlist['name']),
                  subtitle: Text('${playlist['tracks']['total']} tracks'),
                  leading: playlist['images'].isNotEmpty
                      ? Image.network(playlist['images'][0]['url'], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.music_note),
                );
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _fetchPlaylists() async {
    if (token == null) return;
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/playlists'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => playlists = data['items']);
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }
  }

  Future<void> _loadToken() async {
    final savedToken = await SpotifyAuth.getToken();
    if (savedToken != null) {
      setState(() => token = savedToken);
      _fetchPlaylists();
    }
  }
}