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
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
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
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        // Чтобы нельзя было свайпнуть пальцем
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const CharactersListScreen(),
          ChangeNotifierProvider(
            create: (context) => CharactersFavoriteListViewModel(
              context.read<DatabaseRepository>(),
            ),
            child: const FavoritesListScreen(),
          ),
        ],
      ),
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
