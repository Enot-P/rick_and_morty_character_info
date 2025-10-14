import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rick_and_morty_character_info/app/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _CacheKeys {
  static const cacheCharactersId = 'cached_characters';
  static const cacheCharactersNextPageId = 'cached_characters_next_page';
  static const cacheCharactersHasNextPageId = 'cached_characters_has_next_page';
}

class CacheRepository {
  final SharedPreferences pref;

  CacheRepository(this.pref);

  Future<void> saveCharactersNextPage(String nextPageSrc, bool hasNextPage) async {
    await pref.setString(_CacheKeys.cacheCharactersNextPageId, nextPageSrc);
    await pref.setBool(_CacheKeys.cacheCharactersHasNextPageId, hasNextPage);
    debugPrint('[CacheRepository] Successfully saved nextPageSrc and hasNextPage to cache');
  }

  Future<String?> getCharactersNextPage() async {
    final nextPage = pref.getString(_CacheKeys.cacheCharactersNextPageId);
    debugPrint('[CacheRepository] Retrieved $nextPage nextPageSrc from cache');
    return nextPage;
  }

  Future<bool?> getCharactersHasNextPage() async {
    final hasNextPage = pref.getBool(_CacheKeys.cacheCharactersHasNextPageId);
    debugPrint('[CacheRepository] Retrieved $hasNextPage hasNexPage from cache');
    return hasNextPage;
  }

  Future<void> saveCharacters(List<Character> chars) async {
    debugPrint('[CacheRepository] Saving ${chars.length} characters to cache');
    final mergedChars = await _mergeCaracters(chars);
    final jsonList = mergedChars.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await pref.setString(_CacheKeys.cacheCharactersId, jsonString);
    debugPrint('[CacheRepository] Successfully saved ${mergedChars.length} characters to cache');
  }

  Future<List<Character>> getCharacters() async {
    debugPrint('[CacheRepository] Retrieving characters from cache');
    final jsonString = pref.getString(_CacheKeys.cacheCharactersId);
    if (jsonString == null) {
      debugPrint('[CacheRepository] No cached characters found');
      return [];
    }
    final jsonList = jsonDecode(jsonString);
    if (jsonList is! List) throw Exception('Ошибка формата json');
    final characters = jsonList.map((e) => Character.fromJson(e)).toList();
    debugPrint('[CacheRepository] Retrieved ${characters.length} characters from cache');
    return characters;
  }

  Future<List<Character>> _mergeCaracters(List<Character> chars) async {
    final existing = await getCharacters();
    final existingIds = existing.map((c) => c.id).toSet();
    final newChars = chars.where((c) => !existingIds.contains(c.id)).toList();
    final merged = [...existing, ...newChars];
    debugPrint(
      '[CacheRepository] Merged: ${existing.length} existing + ${newChars.length} new = ${merged.length} total',
    );
    return merged;
  }

  Future<void> cleanCache() async {
    await pref.remove(_CacheKeys.cacheCharactersHasNextPageId);
    await pref.remove(_CacheKeys.cacheCharactersId);
    await pref.remove(_CacheKeys.cacheCharactersNextPageId);
  }
}
