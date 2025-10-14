import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/domain/models/models.dart';
import 'package:rick_and_morty_character_info/app/domain/repositories/repositories.dart';

class CharactersListViewModel extends ChangeNotifier {
  final CharacterRepository _charRepo;
  final CacheRepository _cacheRepo;
  final DatabaseRepository _dbRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Character> _characters = [];
  List<Character> get characters => List.unmodifiable(_characters);
  List<Character> _favoritesCharacters = [];

  String? _nextPage;
  bool _hasNextPage = true;

  CharactersListViewModel(this._charRepo, this._cacheRepo, this._dbRepo) {
    _init();
  }
  Future<void> _init() async {
    // await _cacheRepo.cleanCache();
    await _loadCacheCharacters();
    await loadNetworkCharacters();
    await loadFavoritesCharacters();
  }

  Future<void> loadFavoritesCharacters() async {
    _favoritesCharacters = await _dbRepo.getCharactersFavoriteList();
    notifyListeners();
  }

  Future<void> _loadCacheCharacters() async {
    try {
      _isLoading = true;
      _characters = await _cacheRepo.getCharacters();
      _nextPage = await _cacheRepo.getCharactersNextPage();
      _hasNextPage = await _cacheRepo.getCharactersHasNextPage() ?? true;
      if (_characters.isNotEmpty) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке из кеша');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNetworkCharacters() async {
    // Если идет загрузка или страницы закончились
    if (_isLoading || !_hasNextPage) return;
    try {
      debugPrint('loadNetwork Start $_nextPage');
      _isLoading = true;
      notifyListeners();
      // Загружает первые 20 персонажей, если ссылка не указана
      final pageUrl = _nextPage ?? 'character';
      final response = await _charRepo.getCharactersPage(src: pageUrl);
      _characters += response.results;
      _nextPage = response.info.next;
      if (response.info.next == null) _hasNextPage = false;
      await _cacheRepo.saveCharacters(_characters);
      await _cacheRepo.saveCharactersNextPage(pageUrl, _hasNextPage);
    } catch (e) {
      debugPrint('Ошибка при загрузке персонажей из сети');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCharacterFavorite(Character char) async {
    // Вернет -1 если такого элемента нету
    final index = _favoritesCharacters.indexWhere((e) => e.id == char.id);
    if (index >= 0) {
      _favoritesCharacters.removeAt(index);
      await _dbRepo.deleteCharacterInFavorite(char);
    } else {
      _favoritesCharacters.add(char);
      await _dbRepo.addCharacterInFavorite(char);
    }
    notifyListeners();
  }

  bool isFavorite(Character char) {
    return _favoritesCharacters.contains(char);
  }
}
