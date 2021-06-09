import 'dart:convert';
import 'package:cad_sprint/app/screens/sprint/shared/models/util/constants.dart';
import 'package:http/http.dart';
import 'package:cad_sprint/app/screens/sprint/shared/models/sprint.dart';

class SprintApi {

  final Client _client;
  SprintApi(this._client);

  Future<List<Sprint>>fetchSprints() async {
    final response = await _client.get(Uri.parse('${Constants.API_BASE_URL}'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jSprints = json.decode(response.body);
      final sprints = jSprints.map((js) => Sprint.fromJson(js)).toList();

      return sprints;
    }else {
      throw Exception('Erro ao recuperar sprints');
    }
  }

  /*Future<Sprint> postSprint(String title) async {
    final response = await _client.post(Uri.parse('${Constants.API_BASE_URL}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    if (response.statusCode == 201) {
      return Sprint.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao cadastrar uma sprint.');
    }
  }*/
  Future<String> postSprint(Sprint item) async {
    print('Aqui');
    print(item.toRawJsonWithoutId());
    print(item);
    final response = await _client.post(

        Uri.parse('${Constants.API_BASE_URL}'),

        headers: {
          'Accept': Constants.APPLICATION_JSON,
          'content-type': Constants.APPLICATION_JSON,
        },

        body: item.toRawJsonWithoutId());
    print(response);
    print(item.toRawJsonWithoutId());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'Sprint cadastrada com sucesso!';
    } else {
      throw Exception(
          'Erro ao tentar salvar a sprint. StatusCode: ${response.statusCode}');
    }

  }

  Future deleteSprint(int sprintId) async {
    final response = await _client.delete(Uri.parse('${Constants.API_BASE_URL}/sprint/$sprintId'));
    print(response.body);
    if(response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Erro ao deletar sprint');
    }
  }


}