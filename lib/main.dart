import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/domain/repositories/repositories.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_character_info/app/domain/view_models/view_models.dart';
import 'package:rick_and_morty_character_info/features/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json,
    ),
  );
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider(create: (_) => dio),
        Provider(create: (_) => sharedPreferences),
        Provider(create: (context) => CharacterRepository(context.read<Dio>())),
        Provider(create: (context) => CacheRepository(context.read<SharedPreferences>())),
        Provider(create: (context) => DatabaseRepository(context.read<SharedPreferences>())),
        // Global View Models
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ThemeViewModel>();
    return MaterialApp(
      theme: ThemeData(brightness: model.theme),
      home: const HomeScreen(),
    );
  }
}
