import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/models/character_response_model.dart';
import 'package:rick_and_morty_character_info/app/view/widgets/widgets.dart';
import 'package:rick_and_morty_character_info/features/characters_list/domain/characters_list_view_model.dart';

class CharactersListScreen extends StatefulWidget {
  const CharactersListScreen({super.key});

  @override
  State<CharactersListScreen> createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CharactersListViewModel>();
    final character = model.characters;
    final startWidget = model.isLoading
        ? const Center(child: CircularProgressIndicator())
        : CharactersGridWidget(character: character);
    return Scaffold(
      body: Center(child: startWidget),
    );
  }
}

class CharactersGridWidget extends StatelessWidget {
  const CharactersGridWidget({
    super.key,
    required this.character,
  });

  final List<Character> character;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.73,
      ),
      itemCount: character.length,
      itemBuilder: (BuildContext context, int index) {
        final model = context.read<CharactersListViewModel>();
        model.showCharactersByIndex(index);
        return CharacterCardWidget(character: character[index]);
      },
    );
  }
}
