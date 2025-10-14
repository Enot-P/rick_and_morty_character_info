import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/repositories/repositories.dart';
import 'package:rick_and_morty_character_info/features/characters_list/characters_list.dart';
import 'package:rick_and_morty_character_info/features/favoirites_list/favoirites_list.dart';
import 'package:rick_and_morty_character_info/features/home/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> widgetOptions = [
    ChangeNotifierProvider(
      create: (context) => CharactersListViewModel(
        context.read<CharacterRepository>(),
        context.read<CacheRepository>(),
      ),
      child: const CharactersListScreen(),
    ),
    const FavoritesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeViewModel>();
    return Scaffold(
      body: widgetOptions.elementAt(model.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: model.selectedIndex,
        onTap: model.changeSelectedIndex,
      ),
    );
  }
}
