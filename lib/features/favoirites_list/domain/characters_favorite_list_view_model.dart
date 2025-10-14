import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/domain/models/models.dart';
import 'package:rick_and_morty_character_info/app/domain/repositories/repositories.dart';

class CharactersFavoriteListViewModel extends ChangeNotifier {
  final DatabaseRepository _dbRepo;
  CharactersFavoriteListViewModel(this._dbRepo) {
    _init();
  }

  List<Character> _favoritesCharacters = [];
  List<Character> get favoritesCharacters => List.unmodifiable(_favoritesCharacters);

  bool isFavorite(Character char) => _favoritesCharacters.contains(char);

  Future<void> toggleFavorite(Character character) async {
    await _dbRepo.toggleCharacterFavorite(character);
    _favoritesCharacters = await _dbRepo.getCharactersFavoriteList();
    notifyListeners();
  }

  Future<void> _init() async {
    _favoritesCharacters = await _dbRepo.getCharactersFavoriteList();
    notifyListeners();
  }
}
