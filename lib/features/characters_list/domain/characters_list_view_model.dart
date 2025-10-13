import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/app.dart';

class CharactersListViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // TODO: Добавить вывод ошибки
  Object? _error;
  Object? get error => _error;

  final CharacterRepository _charRepo;
  List<Character> _characters = [];
  List<Character> get characters => List.unmodifiable(_characters);
  String? _nextPage;
  bool _hasNextPage = true;

  CharactersListViewModel(this._charRepo) {
    loadCharacters();
  }
  Future<void> loadCharacters() async {
    // Если идет загрузка или страницы закончились
    if (_isLoading || !_hasNextPage) return;
    try {
      _isLoading = true;
      _error = null;
      // Загружает первые 20 персонажей, если ссылка не указана
      final response = await _charRepo.getCharactersPage(src: _nextPage ?? 'character');
      _characters += response.results;
      _nextPage = response.info.next;
      if (response.info.next == null) _hasNextPage = false;
      notifyListeners();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Используется для пагинации
  /// Подгружает новых персонажей ближе к концу прокрутке
  Future<void> showCharactersByIndex(int index) async {
    if (_isLoading) return;
    if (index > _characters.length - 3) await loadCharacters();
  }
}
