import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/models/models.dart';
import 'package:rick_and_morty_character_info/app/view/widgets/widgets.dart';
import 'package:rick_and_morty_character_info/features/favoirites_list/favoirites_list.dart';

class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CharactersFavoriteListViewModel>();
    final favoritesCharacters = model.favoritesCharacters;
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
          itemCount: favoritesCharacters.length,
          itemBuilder: (BuildContext context, int index) {
            return CharacterCardWidget(
              character: favoritesCharacters[index],
              onFavoritePressed: () => model.toggleFavorite(favoritesCharacters[index]),
              isFavorite: model.isFavorite(favoritesCharacters[index]),
            );
          },
        ),
      ),
    );
  }
}
