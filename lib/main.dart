import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_info/app/app.dart';
import 'package:rick_and_morty_character_info/features/home/domain/home_view_model.dart';
import 'package:rick_and_morty_character_info/features/home/view/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://rickandmortyapi.com/api/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true)); // Для логов
    return dio;
  }

  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider(create: (_) => createDio()),
        Provider(create: (context) => CharacterRepository(context.read<Dio>())),
        // Global View Model
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
