import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const String apiRoot = 'https://rickandmortyapi.com/api/character';

Future<Map<String, dynamic>> _fetchPage(http.Client client, String page) async {
  final result = await client.get(Uri.parse(page));

  final json = jsonDecode(result.body) as Map<String, dynamic>;

  return json;
}

void main(List<String> arguments) async {
  final client = http.Client();

  final charactersJson = <Map<String, dynamic>>[];

  String? nextPage = apiRoot;
  while (nextPage != null) {
    print('Fetching $nextPage...');
    final page = await _fetchPage(client, nextPage);
    final results = (page['results'] as List);
    charactersJson.addAll(results.whereType<Map<String, dynamic>>());

    nextPage = (page['info'] as Map<String, dynamic>)['next'] as String?;
  }

  print('Writing full_characters.json');
  final file = File('../full_characters.json');
  await file.writeAsString(jsonEncode(charactersJson));

  print('Done.');
}
