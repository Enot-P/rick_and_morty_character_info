import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/view/widgets/widgets.dart';
import 'package:rick_and_morty_character_info/features/favoirites_list/favoirites_list.dart';

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CharactersFavoriteListViewModel>();
    final favoritesCharacters = model.favoritesCharacters;
    // Сортируем персонажей по имени (алфавитный порядок)
    final sortedCharacters = List.from(favoritesCharacters)..sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.73,
          ),
          itemCount: sortedCharacters.length,
          itemBuilder: (BuildContext context, int index) {
            return CharacterCardWidget(
              character: sortedCharacters[index],
              onFavoritePressed: () => model.deleteFromFavorite(sortedCharacters[index]),
              isFavorite: model.isFavorite(sortedCharacters[index]),
            );
          },
        ),
      ),
    );
  }
}
