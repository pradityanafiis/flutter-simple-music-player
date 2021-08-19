import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final _baseUrl = 'https://itunes.apple.com/search';

  Future<dynamic> searchArtist(String artistName) async {
    try {
      final String _url = '$_baseUrl?term=$artistName&country=ID&media=music';
      final _response = await http.get(Uri.parse(_url));
      if (_response.statusCode == 200)
        return jsonDecode(_response.body);
      else
        return Exception('Something went wrong!');
    } catch (e) {
      return e;
    }
  }
}
