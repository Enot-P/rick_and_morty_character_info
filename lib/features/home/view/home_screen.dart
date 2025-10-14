import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/repositories/repositories.dart';
import 'package:rick_and_morty_character_info/app/domain/view_models/theme_view_model.dart';
import 'package:rick_and_morty_character_info/features/characters_list/characters_list.dart';
import 'package:rick_and_morty_character_info/features/favoirites_list/favoirites_list.dart';

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
        context.read<DatabaseRepository>(),
      ),
      child: const CharactersListScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => CharactersFavoriteListViewModel(context.read<DatabaseRepository>()),
      child: const FavoritesListScreen(),
    ),
  ];

  int _selectedIndex = 0;
  _onTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final modalTheme = context.watch<ThemeViewModel>();
    final themeIcon = modalTheme.theme == Brightness.light ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => modalTheme.toggleTheme(),
            icon: themeIcon,
          ),
        ],
      ),
      body: widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
