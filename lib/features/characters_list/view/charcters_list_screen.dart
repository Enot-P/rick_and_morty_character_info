import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/models/character_response_model.dart';
import 'package:rick_and_morty_character_info/app/view/widgets/widgets.dart';
import 'package:rick_and_morty_character_info/features/characters_list/domain/characters_list_view_model.dart';

class CharactersListScreen extends StatelessWidget {
  const CharactersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CharactersListViewModel>();
    final character = model.characters;
    final Widget startWidget;
    if (model.isLoading && model.characters.isEmpty) {
      startWidget = const Center(child: CircularProgressIndicator());
    } else if (!model.isLoading && model.characters.isEmpty) {
      startWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Проверьте соединение с интернетом'),
          ElevatedButton(
            onPressed: () => model.loadNetworkCharacters(),
            child: const Text('Обновить'),
          ),
        ],
      );
    } else {
      startWidget = CharactersGridWidget(character: character);
    }
    return Scaffold(
      body: Center(child: startWidget),
    );
  }
}

class CharactersGridWidget extends StatefulWidget {
  const CharactersGridWidget({
    super.key,
    required this.character,
  });

  final List<Character> character;

  @override
  State<CharactersGridWidget> createState() => _CharactersGridWidgetState();
}

class _CharactersGridWidgetState extends State<CharactersGridWidget> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Если докрутили до 80% списка — подгружаем
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final model = context.read<CharactersListViewModel>();
      model.loadNetworkCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        controller: _scrollController,
        key: const PageStorageKey<String>('characters_grid'),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.73,
        ),
        itemCount: widget.character.length,
        itemBuilder: (BuildContext context, int index) {
          return CharacterCardWidget(character: widget.character[index]);
        },
      ),
    );
  }
}
