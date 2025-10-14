import 'dart:convert';

import 'package:rick_and_morty_character_info/app/domain/models/character_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _DataBaseKeys {
  static const dbCharacterKey = 'db_character';
}

class DatabaseRepository {
  final SharedPreferences pref;

  DatabaseRepository(this.pref);

  Future<List<Character>> getCharactersFavoriteList() async {
    final charactersString = pref.getString(_DataBaseKeys.dbCharacterKey);
    if (charactersString == null || charactersString.isEmpty) return [];
    final jsonCharacters = jsonDecode(charactersString) as List;
    final characters = jsonCharacters.map((e) => Character.fromJson(e)).toList();
    return characters;
  }

  Future<void> toggleCharacterFavorite(Character char) async {
    final currentFavorites = await getCharactersFavoriteList();
    currentFavorites.contains(char) ? currentFavorites.remove(char) : currentFavorites.add(char);
    await _saveFavoritesList(currentFavorites);
  }

  Future<void> addCharacterInFavorite(Character char) async {
    final currentFavorites = await getCharactersFavoriteList();

    if (currentFavorites.contains(char)) return;
    currentFavorites.add(char);
    await _saveFavoritesList(currentFavorites);
  }

  Future<void> deleteCharacterInFavorite(Character char) async {
    final currentFavorites = await getCharactersFavoriteList();
    currentFavorites.remove(char);
    await _saveFavoritesList(currentFavorites);
  }

  Future<void> _saveFavoritesList(List<Character> newChars) async {
    final jsonList = newChars.map((e) => e.toJson()).toList();
    final stringJson = jsonEncode(jsonList);
    await pref.setString(_DataBaseKeys.dbCharacterKey, stringJson);
  }
}
