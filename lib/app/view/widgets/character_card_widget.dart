import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rick_and_morty_character_info/app/domain/models/models.dart';
import 'package:rick_and_morty_character_info/features/home/domain/home_view_model.dart';

class CharacterCardWidget extends StatelessWidget {
  const CharacterCardWidget({super.key, required this.character});
  final Character character;
  @override
  Widget build(BuildContext context) {
    final origin = character.origin == 'unknown' ? '' : character.origin;
    return Card(
      child: Column(
        children: [
          _ChapterImageWidget(character: character),

          Expanded(
            child: _ChapterInfoWidget(
              name: character.name,
              type: character.type,
              species: character.species,
              origin: origin,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterInfoWidget extends StatelessWidget {
  const _ChapterInfoWidget({
    required this.name,
    required this.type,
    required this.species,
    required this.origin,
  });

  final String name;
  final String type;
  final String species;
  final String origin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          origin.isEmpty ? name : '$name $origin',
          style: const TextStyle(
            fontSize: 15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),

        Text(
          type.isNotEmpty ? '$species - $type' : species,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ChapterImageWidget extends StatelessWidget {
  const _ChapterImageWidget({required this.character});

  final Character character;

  _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeViewModel>();
    final isFavorite = model.isFavorite(character.id);
    final iconColor = isFavorite ? Colors.red : Colors.white;
    return Stack(
      children: [
        // фотография персонажа
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadiusGeometry.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: character.image,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),

        // Status персонажа (жив/мертв/неизвестно)
        Positioned(
          top: 7,
          left: 5,
          child: Container(
            decoration: BoxDecoration(
              color: _getStatusColor(character.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                character.status,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),

        // Кнопка лайка
        Positioned(
          top: 7,
          right: 5,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(iconColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => model.toggleFavorite(character),
            icon: const Icon(Icons.favorite),
          ),
        ),
      ],
    );
  }
}
