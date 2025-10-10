import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/domain/models/character_response_model.dart';

class CharacterRepository {
  Future<void> getCharactersList() async {
    final response = await Dio().get('https://rickandmortyapi.com/api/character');
    final result = CharacterResponse.fromJson(response.data);
    debugPrint(result.results.first.toString());
  }
}
