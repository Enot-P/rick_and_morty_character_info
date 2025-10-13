// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import 'package:rick_and_morty_character_info/app/domain/models/character_response_model.dart';

class CharacterRepository {
  final Dio _dio;
  CharacterRepository(this._dio);

  /// Дает 1 страницу персонажей. В 1 странице 20 персонажей
  Future<CharacterResponse> getCharactersPage({String src = 'character'}) async {
    final response = await _dio.get(src);
    if (response.statusCode == 200) {
      final result = CharacterResponse.fromJson(response.data);
      return result;
    } else {
      throw Exception("Ошибка при запросе getCharacterList");
    }
  }
}
