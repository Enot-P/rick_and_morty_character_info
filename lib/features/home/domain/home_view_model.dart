import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/domain/models/models.dart';

class HomeViewModel extends ChangeNotifier {
  final Set<int> _favoriteIds = {};
  Set<int> get favoitreIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(int id) => _favoriteIds.contains(id);

  void toggleFavorite(Character character) {
    if (!_favoriteIds.add(character.id)) {
      _favoriteIds.remove(character.id);
    }
    notifyListeners();
  }
}
